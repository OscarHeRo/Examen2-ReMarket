# 5. API REST — Caso de Estudio `POST /pedido`

El endpoint `POST /pedido` es el más crítico del flujo de compra: coordina la confirmación del pago, la reserva de inventario y la emisión de órdenes.

```http
POST /api/v1/pedidos HTTP/1.1
Host: api.remarket.com
Authorization: Bearer eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9...
Idempotency-Key: 9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d
Content-Type: application/json

{"items": [{"id": "SKU-102", "cant": 1}], "payment_token": "tok_1N2eZ4LkdIwHu7ix"}
```

### Controles de Seguridad en la Petición
1. **Autenticación y Autorización (Capa 7):** Token **JWT** firmado con **ECDSA P-256 (`ES256`)** de 15 min. Se valida que el usuario (`sub`) sea el dueño del pedido, evitando que alguien altere pedidos ajenos (falla **BOLA**).
2. **Idempotencia y Anti-Replay:** Cabecera `Idempotency-Key` (UUIDv4) guardada en **Redis** (TTL 120 s). Si la red falla y se reintenta, el cliente recibe la respuesta en caché sin duplicar cobros ni órdenes.
3. **Confidencialidad e Integridad:** Conexión de punta a punta con TLS 1.3 y suites AEAD.
4. **Minimización de Datos:** El cuerpo **no contiene tarjeta (PAN), CVV ni vencimiento**. Solo viaja un token opaco (`payment_token`) emitido por Stripe Elements, cumpliendo con PCI-DSS SAQ-A.
