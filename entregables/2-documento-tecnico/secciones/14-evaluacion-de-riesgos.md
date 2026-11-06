# 14. Evaluación y Gestión de Riesgos

Nivel de riesgo = Impacto (1–3) × Probabilidad (1–3). Rangos: **6–9 Alto**, **3–4 Medio**, **1–2 Bajo**. La matriz completa, con riesgo residual, está en el Entregable 3.

| ID | Categoría | Activo | Amenaza | Vulnerabilidad | I | P | Nivel |
| :---: | :--- | :--- | :--- | :--- | :---: | :---: | :---: |
| **R1** | Credenciales | Claves de AWS y Stripe | Robo de secretos | Secretos en código o en el repositorio | 3 | 2 | **6 Alto** |
| **R2** | Comunicaciones | Tráfico entre pods | Espionaje o suplantación este-oeste | Red interna sin autenticación mutua | 3 | 1 | **3 Medio** |
| **R3** | Almacenamiento | Respaldos de BD | Robo o borrado de respaldos | Snapshots sin cifrar o en la misma cuenta | 3 | 2 | **6 Alto** |
| **R4** | Disponibilidad | Tienda en línea | DDoS en temporada alta | Capacidad fija, sin filtrado en el borde | 3 | 3 | **9 Alto** |
| **R5** | Cadena de suministro | Imágenes en producción | Dependencia o imagen maliciosa | Sin SCA ni verificación de firma | 3 | 2 | **6 Alto** |
| **R6** | Pagos | Confirmación de cobros | Webhook falso de "pago aprobado" | Webhook sin verificación de firma | 3 | 2 | **6 Alto** |
| **R7** | Terceros | Avisos por SMS | Caída del proveedor de SMS | Un solo proveedor | 1 | 2 | **2 Bajo** |

### Tratamiento de los Riesgos Prioritarios

| Riesgo | Tipo de tratamiento | Preventivo | Detectivo | Correctivo |
| :--- | :--- | :--- | :--- | :--- |
| **R1** | Mitigación | Gitleaks en pre-commit y CI, OIDC sin claves fijas | Secret scanning de GitHub y alarmas de CloudTrail | Revocar y rotar en Secrets Manager; revisar CloudTrail |
| **R4** | Mitigación + transferencia | CloudFront, Shield Advanced y WAF (500 req/min por IP) | Alarmas de CloudWatch por latencia y errores 5xx | Autoescalado HPA/Karpenter y *runbook* de respuesta; el costo del escalado por DDoS lo cubre la protección de costos de Shield Advanced (transferencia) |
| **R6** | Mitigación + transferencia | HMAC-SHA256 en tiempo constante, ventana de 300 s y `event.id` único | Alerta en SIEM por firmas inválidas | Bloqueo en WAF y conciliación con Stripe; el manejo de tarjetas se transfiere a Stripe (PCI SAQ-A) |
| **R7** | Aceptación | — | Alarma de errores del proveedor | El correo sigue funcionando; un retraso de SMS no detiene ventas |
