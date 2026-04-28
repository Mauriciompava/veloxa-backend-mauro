package org.cesde.velotax.dto;

import lombok.*;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class QuoteRequest {
    @NotBlank(message = "El origen es requerido")
    private String origin;
    
    @NotBlank(message = "El destino es requerido")
    private String destination;
    
    @NotNull(message = "El peso es requerido")
    @DecimalMin(value = "0.1", message = "El peso debe ser mayor a 0")
    private BigDecimal weight;
    
    @NotBlank(message = "El tipo de servicio es requerido")
    private String serviceType;
}
