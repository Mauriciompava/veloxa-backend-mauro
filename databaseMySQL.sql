-- ============================================================================
-- BASE DE DATOS: veloxa_db
-- DESCRIPCIÓN: Sistema de gestión de logística y envíos
-- ============================================================================

DROP DATABASE IF EXISTS veloxa_db;
CREATE DATABASE veloxa_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE veloxa_db;

-- ============================================================================
-- TABLA: users
-- ============================================================================
CREATE TABLE users (
    id BIGINT NOT NULL AUTO_INCREMENT,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    company VARCHAR(100),
    phone VARCHAR(20),
    role ENUM('admin', 'user', 'support') DEFAULT 'user',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    PRIMARY KEY (id),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB;

-- ============================================================================
-- TABLA: recipients
-- ============================================================================
CREATE TABLE recipients (
    id BIGINT NOT NULL AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    address VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_recipients_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB;

-- ============================================================================
-- TABLA: shipments
-- ============================================================================
CREATE TABLE shipments (
    id BIGINT NOT NULL AUTO_INCREMENT,
    tracking_number VARCHAR(20) NOT NULL UNIQUE,
    user_id BIGINT NOT NULL,
    recipient_id BIGINT NOT NULL,
    origin VARCHAR(50) NOT NULL,
    destination VARCHAR(50) NOT NULL,
    total_weight DECIMAL(10,2) NOT NULL,
    service_type ENUM('standard', 'express', 'overnight', 'premium', 'economic') NOT NULL,
    total_value_declared DECIMAL(12,2),
    insurance BOOLEAN DEFAULT false,
    status ENUM('Pendiente', 'Recogido', 'En tránsito', 'En reparto', 'Entregado', 'Cancelado', 'Excepción') DEFAULT 'Pendiente',
    estimated_cost DECIMAL(12,2) NOT NULL,
    estimated_delivery_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_shipments_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_shipments_recipient FOREIGN KEY (recipient_id) REFERENCES recipients(id) ON DELETE RESTRICT,
    INDEX idx_user_created (user_id, created_at DESC),
    INDEX idx_status (status)
) ENGINE=InnoDB;

-- ============================================================================
-- TABLA: shipment_items
-- ============================================================================
CREATE TABLE shipment_items (
    id BIGINT NOT NULL AUTO_INCREMENT,
    shipment_id BIGINT NOT NULL,
    description VARCHAR(150) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    weight_per_unit DECIMAL(10,2),
    value_per_unit DECIMAL(12,2),
    PRIMARY KEY (id),
    CONSTRAINT fk_items_shipment FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE,
    INDEX idx_shipment_id (shipment_id)
) ENGINE=InnoDB;

-- ============================================================================
-- TABLA: shipment_timeline
-- ============================================================================
CREATE TABLE shipment_timeline (
    id BIGINT NOT NULL AUTO_INCREMENT,
    shipment_id BIGINT NOT NULL,
    status ENUM('Pendiente', 'Recogido', 'En tránsito', 'En reparto', 'Entregado', 'Cancelado', 'Excepción') NOT NULL,
    location VARCHAR(100) NOT NULL,
    event_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT,
    PRIMARY KEY (id),
    CONSTRAINT fk_timeline_shipment FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE,
    INDEX idx_timeline_query (shipment_id, event_timestamp DESC)
) ENGINE=InnoDB;

-- ============================================================================
-- TABLA: contacts (Soporte/Tickets)
-- ============================================================================
CREATE TABLE contacts (
    id BIGINT NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    company VARCHAR(100),
    subject VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    category VARCHAR(50),
    ticket_number VARCHAR(20) NOT NULL UNIQUE,
    status ENUM('Nuevo', 'En proceso', 'Resuelto', 'Cerrado') DEFAULT 'Nuevo',
    priority ENUM('Baja', 'Media', 'Alta', 'Crítica') DEFAULT 'Media',
    assigned_to BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    responded_at TIMESTAMP NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_contacts_assigned FOREIGN KEY (assigned_to) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_status_created (status, created_at DESC)
) ENGINE=InnoDB;

-- ============================================================================
-- TABLA: quotes
-- ============================================================================
CREATE TABLE quotes (
    id BIGINT NOT NULL AUTO_INCREMENT,
    user_id BIGINT,
    origin VARCHAR(50) NOT NULL,
    destination VARCHAR(50) NOT NULL,
    weight DECIMAL(10,2) NOT NULL,
    service_type ENUM('standard', 'express', 'overnight', 'premium', 'economic') NOT NULL,
    base_cost DECIMAL(12,2) NOT NULL,
    distance_factor DECIMAL(5,2) DEFAULT 1,
    total_cost DECIMAL(12,2) NOT NULL,
    estimated_days VARCHAR(10),
    valid_until TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_quotes_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB;

-- ============================================================================
-- TABLA: audit_log
-- ============================================================================
CREATE TABLE audit_log (
    id BIGINT NOT NULL AUTO_INCREMENT,
    user_id BIGINT,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50),
    entity_id BIGINT,
    details JSON,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB;

-- ============================================================================
-- VISTAS
-- ============================================================================

CREATE OR REPLACE VIEW view_active_shipments AS
SELECT 
    s.id, 
    s.tracking_number, 
    s.origin, 
    s.destination, 
    s.status, 
    s.estimated_delivery_date,
    u.email as customer_email,
    r.full_name as recipient_name
FROM shipments s
JOIN users u ON s.user_id = u.id
JOIN recipients r ON s.recipient_id = r.id
WHERE s.status NOT IN ('Entregado', 'Cancelado');

CREATE OR REPLACE VIEW view_pending_contacts AS
SELECT id, ticket_number, full_name, email, category, subject, priority, created_at, status
FROM contacts
WHERE status IN ('Nuevo', 'En proceso');

-- ============================================================================
-- DATOS DE SEMILLA (SEED)
-- ============================================================================

-- 1. Usuarios (Password de ejemplo)
INSERT INTO users (id, email, password_hash, full_name, role) VALUES
(1, 'admin@veloxa.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86E36P4/VoO', 'Admin Veloxa', 'admin'),
(2, 'cliente@pro.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86E36P4/VoO', 'Juan García', 'user');

-- 2. Destinatarios
INSERT INTO recipients (id, user_id, full_name, phone, address) VALUES
(1, 2, 'Distribuidora Norte', '+52 81 1234 5678', 'Av. Universidad 456, Monterrey, NL');

-- 3. Envíos
INSERT INTO shipments (id, tracking_number, user_id, recipient_id, origin, destination, total_weight, service_type, status, estimated_cost, estimated_delivery_date) VALUES
(1, 'VEL-2024-0001', 2, 1, 'CDMX', 'Monterrey', 12.50, 'express', 'En tránsito', 450.00, DATE_ADD(CURDATE(), INTERVAL 2 DAY));

-- 4. Ítems
INSERT INTO shipment_items (shipment_id, description, quantity, weight_per_unit) VALUES
(1, 'Caja de Herramientas Pro', 1, 10.00),
(1, 'Kit de Limpieza', 1, 2.50);

-- 5. Historial (Timeline)
INSERT INTO shipment_timeline (shipment_id, status, location, description) VALUES
(1, 'Pendiente', 'CDMX', 'Orden creada en sistema'),
(1, 'Recogido', 'CDMX', 'El mensajero ha recolectado el paquete'),
(1, 'En tránsito', 'Centro de Distribución Bajío', 'Paquete en ruta a destino');