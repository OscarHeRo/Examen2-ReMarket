# 9. Pasarela de Pagos

El procesamiento de cobros se delega a **Stripe Elements** bajo **PCI-DSS SAQ-A**, reduciendo el riesgo al mínimo:

### Flujo de Datos y Alcance PCI
1. **Datos de la pasarela:** El cliente escribe su tarjeta (PAN), CVV y fecha de vencimiento dentro de un *iframe* seguro de Stripe. ReMarket **jamás ve ni guarda números de tarjeta en texto claro**.
2. **Datos recibidos por ReMarket:** Stripe devuelve un `payment_token` temporal, que mandamos a nuestro servicio de pagos junto con el ID de orden y monto.
3. **Protección del checkout:** Para evitar robo de datos en el navegador (*Magecart*), usamos CSP estricta (`script-src 'self' https://js.stripe.com; frame-src https://js.stripe.com`) y firmas SRI en los scripts.

### Verificación del Webhook `POST /payment-confirmed`
Para evitar que un atacante mande avisos falsos de cobros aprobados y la tienda envíe paquetes sin haber cobrado, aplicamos triple validación:

1. **Firma HMAC-SHA256:** Stripe manda en `Stripe-Signature` la firma calculada con el secreto del webhook:
   $$\text{Firma} = \text{HMAC-SHA256}(\text{secret}, t \parallel \text{payload})$$
   El servicio recalcula el hash con el secreto en AWS Secrets Manager y usa **comparación en tiempo constante** (`crypto.timingSafeEqual`) para evitar ataques de canal lateral por análisis de tiempos.
2. **Ventana Anti-Replay:** Se descartan peticiones cuya fecha $t$ varíe en más de 300 segundos con el reloj del servidor (NTP), evitando que alguien capture y reenvíe una notificación vieja.
3. **Confirmación Out-of-Band:** Como doble chequeo antes de despachar, el servicio le pregunta directo a Stripe (`GET /v1/charges/{id}`) sobre TLS 1.3 para confirmar en sus sistemas que el cobro es real y está pagado.
