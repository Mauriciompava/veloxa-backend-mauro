package org.cesde.velotax.dto;

import lombok.*;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreateShipmentRequest {
    @NotBlank(message = "El origen es requerido")
    private String origin;
    
    @NotBlank(message = "El destino es requerido")
    private String destination;
    
    @NotNull(message = "El peso es requerido")
    @DecimalMin(value = "0.1", message = "El peso debe ser mayor a 0")
    private BigDecimal weight;
    
    @NotBlank(message = "El tipo de servicio es requerido")
    private String serviceType;
    
    @NotBlank(message = "El nombre del destinatario es requerido")
    private String recipient;
    
    @NotBlank(message = "El teléfono es requerido")
    @Pattern(regexp = "^[0-9+\\-\\s()]+$", message = "Formato de teléfono inválido")
    private String phone;
    
    @NotBlank(message = "El email es requerido")
    @Email(message = "Email inválido")
    private String email;
    
    @NotBlank(message = "La dirección es requerida")
    private String address;
    
    private List<ShipmentItemRequest> items;
    
    @DecimalMin(value = "0", message = "El valor declarado no puede ser negativo")
    private BigDecimal valueDeclaration;
    
    @Builder.Default
    private Boolean insurance = false;
    
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class ShipmentItemRequest {
        @NotBlank(message = "La descripción del artículo es requerida")
        private String description;
        
        @Builder.Default
        @Min(value = 1, message = "La cantidad debe ser mayor a 0")
        private Integer quantity = 1;
        
        @DecimalMin(value = "0.1", message = "El peso debe ser mayor a 0")
        private BigDecimal weightPerUnit;
        
        @DecimalMin(value = "0", message = "El valor no puede ser negativo")
        private BigDecimal valuePerUnit;
    }
}
