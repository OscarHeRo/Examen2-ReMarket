# 9. Pasarela de Pagos

El procesamiento de cobros se delega a **Stripe** con **Stripe Elements**, lo que deja a ReMarket en el alcance mínimo de PCI-DSS (**SAQ-A**).

### Flujo Usuario → ReMarket → Pasarela
1. **Lo que maneja directamente la pasarela:** El cliente escribe número de tarjeta (PAN), CVV y vencimiento dentro de un *iframe* servido por Stripe; esos datos van del navegador a Stripe sin pasar por nuestros servidores.
2. **Lo que recibe ReMarket:** Un identificador opaco del método de pago (`pm_...`) y, tras el cobro, el ID del `PaymentIntent`, su estado y los últimos 4 dígitos y marca para mostrarlos al cliente.
3. **Lo que nunca se almacena:** PAN completo, CVV (tampoco lo guarda Stripe tras autorizar), banda magnética ni PIN.
4. **Comunicaciones a proteger:** navegador ↔ Stripe (TLS, lo controla Stripe); Pagos → API de Stripe (TLS + llave secreta restringida guardada en Secrets Manager); Stripe → nuestro webhook (TLS + firma HMAC).
5. **Protección del checkout:** Contra robo de datos en el navegador (*Magecart*), CSP estricta (`script-src 'self' https://js.stripe.com; frame-src https://js.stripe.com; connect-src 'self' https://api.stripe.com`) y SRI en **nuestros** scripts. Stripe.js no admite SRI porque se actualiza; se carga siempre desde `js.stripe.com`.

### Verificación del Webhook `POST /payment-confirmed`
Para impedir que un atacante envíe un "pago aprobado" falso y la tienda despache sin cobrar, el servicio de Pagos aplica cuatro verificaciones antes de confirmar:

1. **Firma HMAC-SHA256:** Stripe envía en `Stripe-Signature` la marca de tiempo `t` y la firma $\text{HMAC-SHA256}(\text{secreto}, t \,\|\, \text{"."} \,\|\, \text{cuerpo})$. El servicio la recalcula con el secreto guardado en Secrets Manager y compara en **tiempo constante**. Sin el secreto, el atacante no puede producir una firma válida.
2. **Ventana de tiempo:** Se rechaza si `t` difiere más de 300 s del reloj del servidor (NTP), así no se puede reenviar una notificación vieja capturada.
3. **Idempotencia por evento:** El `event.id` procesado se guarda; un reenvío dentro de la ventana se ignora.
4. **Confirmación con el proveedor:** Antes de despachar, Pagos consulta `GET /v1/payment_intents/{id}` y comprueba que el estado sea `succeeded` y que **monto y moneda coincidan con el pedido**. Sólo entonces publica `PedidoPagado`.
