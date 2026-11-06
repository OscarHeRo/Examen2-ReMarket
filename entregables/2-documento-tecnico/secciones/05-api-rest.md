# 5. API REST — Caso de Estudio `POST /pedido`

`POST /pedido` es el endpoint más crítico del flujo de compra: crea la orden, reserva inventario e inicia el cobro.

```http
POST /pedido HTTP/1.1
Host: api.remarket.com
Authorization: Bearer eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9...
Idempotency-Key: 9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d
Content-Type: application/json

{"items": [{"sku": "SKU-102", "cantidad": 1}], "direccion_id": "dir_31", "payment_method": "pm_1N2eZ4LkdIwHu7ix"}
```

### Controles de Seguridad en la Petición
1. **Autenticación:** JWT de acceso firmado con **ECDSA P-256 (`ES256`)**, vigencia de 15 min. El Gateway verifica firma, `exp`, `aud` e `iss`. El token vive sólo en memoria de la SPA; el token de refresco va en una cookie `HttpOnly; Secure; SameSite=Strict`, inaccesible para JavaScript ante un XSS.
2. **Autorización:** El cliente se toma del `sub` del token, nunca del cuerpo, y `direccion_id` debe pertenecer a ese `sub`. Así nadie crea pedidos a nombre de otro ni usa direcciones ajenas (falla **BOLA**).
3. **Protección contra repetición (*replay*):** Cabecera `Idempotency-Key` (UUIDv4) guardada en **Redis** durante **24 h**, más que la vida del token. Un reenvío, por error de red o malicioso, devuelve la respuesta original sin duplicar cobro ni orden.
4. **Confidencialidad e integridad:** Todo viaja cifrado con TLS (sección 3) y mTLS dentro del clúster (sección 4).
5. **Minimización de datos:** El cuerpo **no contiene tarjeta, CVV ni vencimiento**, sólo el identificador opaco que emite Stripe Elements (PCI-DSS SAQ-A). Tampoco viaja **precio ni total**: el servidor los calcula desde el catálogo, así que el cliente no puede alterarlos. La dirección se referencia por ID, sin reenviar los datos personales.
