package org.cesde.velotax.dto;

import lombok.*;
import jakarta.validation.constraints.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ContactRequest {
    @NotBlank(message = "El nombre completo es requerido")
    @Size(min = 3, max = 100, message = "El nombre debe tener entre 3 y 100 caracteres")
    private String fullName;
    
    @NotBlank(message = "El email es requerido")
    @Email(message = "Email inválido")
    private String email;
    
    @Pattern(regexp = "^[0-9+\\-\\s()]*$", message = "Formato de teléfono inválido")
    private String phone;
    
    @Size(max = 100, message = "La empresa no puede exceder 100 caracteres")
    private String company;
    
    @NotBlank(message = "El asunto es requerido")
    @Size(min = 5, max = 255, message = "El asunto debe tener entre 5 y 255 caracteres")
    private String subject;
    
    @NotBlank(message = "El mensaje es requerido")
    @Size(min = 10, max = 5000, message = "El mensaje debe tener entre 10 y 5000 caracteres")
    private String message;
    
    @Size(max = 50, message = "La categoría no peut exceder 50 caracteres")
    private String category;
}
