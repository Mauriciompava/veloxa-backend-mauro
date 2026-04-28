package org.cesde.velotax.controller;

import org.cesde.velotax.dto.ApiResponse;
import org.cesde.velotax.dto.ShipmentResponse;
import org.cesde.velotax.service.ShipmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/track")
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:3001"})
public class TrackingController {
    
    @Autowired
    private ShipmentService shipmentService;
    
    @GetMapping("/{trackingNumber}")
    public ResponseEntity<ApiResponse<ShipmentResponse>> trackShipment(
            @PathVariable String trackingNumber) {
        try {
            ShipmentResponse response = shipmentService.getShipmentByTrackingNumber(trackingNumber);
            return ResponseEntity.ok(ApiResponse.success(response));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error("Envío no encontrado", e.getMessage()));
        }
    }
}
