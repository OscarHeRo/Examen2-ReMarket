# 11. Comunicación Asíncrona (Cola de Eventos)

Para no hacer esperar al cliente, lo que ocurre después de crear o pagar un pedido se procesa en diferido con **Amazon SNS → SQS**: Pedidos y Pagos publican en un tema SNS, y cada consumidor tiene su propia cola SQS suscrita (*fan-out*), así un mismo evento llega a todos.

```
PedidoCreado (Pedidos) ──┐                      ┌──> cola Notificaciones (correo/SMS)
                         ├──> tema SNS ─────────┤
PedidoPagado (Pagos) ────┘                      └──> cola Inventario (descontar existencias)
```

### Controles de Seguridad en la Mensajería
1. **Autenticación del productor y del consumidor:** Cada servicio usa credenciales temporales de su rol IAM (IRSA), y cada petición a SNS/SQS va firmada con **SigV4**. No hay contraseñas compartidas.
2. **Protección del canal:** El tráfico va por **VPC Endpoints** privados con TLS; las políticas de tema y cola exigen la condición `aws:SourceVpce`, así que no se puede publicar desde Internet aunque se tengan credenciales.
3. **Permisos mínimos:** Sólo el rol de Pedidos puede publicar `PedidoCreado` y sólo el de Pagos `PedidoPagado` (`sns:Publish`). Notificaciones e Inventario sólo tienen `sqs:ReceiveMessage` y `sqs:DeleteMessage` sobre **su** cola; ningún consumidor puede publicar.
4. **Integridad del evento:** Temas y colas se cifran con **SSE-KMS**. Además, `PedidoPagado` lleva una firma **ECDSA P-256** hecha con una clave asimétrica de KMS que sólo Pagos puede usar; Inventario y Notificaciones la verifican con la clave pública antes de actuar.
5. **Eventos repetidos o fallidos:** Cada evento lleva un ID único y los consumidores ignoran los ya procesados (idempotencia). Los mensajes que fallan varias veces van a una cola de mensajes fallidos (**DLQ**) con alarma.

### ¿Qué pasaría si un atacante publicara mensajes falsos?
Un `PedidoPagado` falso haría que el almacén enviara mercancía no pagada; compras o cancelaciones inventadas desfasarían el inventario (sobreventa), y miles de eventos falsos agotarían el presupuesto de SMS/correo y llevarían el dominio a listas negras de spam.

Para lograrlo el atacante necesitaría el rol IAM del productor, estar dentro de la VPC **y**, en el caso de `PedidoPagado`, usar la clave de firma de KMS; tres barreras independientes.
