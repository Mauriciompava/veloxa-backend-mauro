# Plan de Ejecución y Correcciones: BACKEND-VELOXA

Este documento detalla las correcciones realizadas y los pasos necesarios para ejecutar el proyecto en IntelliJ IDEA de manera profesional.

## 🛠 Correcciones Realizadas

### 1. Corrección de Versión de Spring Boot
- **Problema:** El archivo `pom.xml` tenía la versión `4.0.3`, la cual no existe como versión estable (Spring Boot 3.x es la actual).
- **Solución:** Se degradó a la versión **3.3.4**, que es estable y compatible con Java 17/21+.

### 2. Sincronización de Tipos de Servicio (Enums)
- **Problema:** Había una discrepancia entre la lógica de negocio (`economic`, `premium`), los Enums de Java y la definición de la base de datos SQL.
- **Solución:** Se actualizaron las entidades `Shipment` y `Quote`, y el script `databaseMySQL.sql` para incluir todos los tipos: `STANDARD, EXPRESS, OVERNIGHT, PREMIUM, ECONOMIC`.

### 3. Corrección de Propiedades de Secretos
- **Problema:** `application-secrets.properties` usaba nombres de propiedades incorrectos (`spring.datasource.mysql.username`) que no coincidían con la configuración de `DatabaseConfig.java`.
- **Solución:** Se ajustaron los nombres a `spring.datasource.username` y `spring.datasource.password`.

---

## 🚀 Pasos para Ejecutar en IntelliJ IDEA

Para que el backend funcione correctamente, sigue estos pasos:

### Paso 1: Importar el Proyecto
1. Abre IntelliJ IDEA.
2. Selecciona **File > Open** y elige la carpeta `BACKEND-VELOXA`.
3. Si IntelliJ te pregunta, selecciona **"Open as Project"** y luego **"Trust Project"**.
4. Asegúrate de que detecte el archivo `pom.xml`. Si no lo hace, haz clic derecho sobre `pom.xml` y selecciona **"Add as Maven Project"**.

### Paso 2: Configurar el SDK (Java)
1. Ve a **File > Project Structure > Project**.
2. Asegúrate de que el **SDK** esté configurado en **Java 21** o superior.
3. El **Project language level** debe ser **21**.

### Paso 3: Preparar la Base de Datos (MySQL)
1. Abre tu cliente de MySQL (Workbench, DBeaver o la terminal).
2. Ejecuta el script completo [databaseMySQL.sql](./databaseMySQL.sql).
   - *Nota: Esto creará la base de datos `veloxa_db`, las tablas, triggers, vistas y datos de prueba.*
3. Verifica que el servicio de MySQL esté corriendo en el puerto `3306`.

### Paso 4: Ejecutar la Aplicación
1. Busca la clase `BackendVeloxaApplication.java` en `src/main/java/org/cesde/velotax/`.
2. Haz clic derecho en el icono verde de "Play" junto al método `main` y selecciona **"Run 'BackendVeloxaApplication'"**.
3. El servidor debería iniciar en `http://localhost:8080`.

---

## 🔍 Verificación de Funcionamiento

Una vez iniciada, puedes probar los siguientes endpoints:

- **Cotizaciones:** `POST http://localhost:8080/api/quotes`
- **Contacto:** `POST http://localhost:8080/api/contact`
- **Rastreo:** `GET http://localhost:8080/api/track/VEL-0000000001`

---

## 📌 Notas Adicionales
- **Lombok:** Asegúrate de tener instalado el plugin de Lombok en IntelliJ y activada la opción **"Enable annotation processing"** en `Settings > Build, Execution, Deployment > Compiler > Annotation Processors`.
- **CORS:** La configuración actual permite peticiones desde `http://localhost:3000` y `http://localhost:3001` (React frontend).
