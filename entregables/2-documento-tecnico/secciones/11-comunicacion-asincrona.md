# 11. Comunicación Asíncrona (Cola de Eventos)

Para desacoplar el flujo de compra y evitar esperas en el navegador del cliente, las operaciones posteriores a la confirmación de la orden se procesan en diferido mediante **Amazon SQS / Apache Kafka**:
$$\text{Pedido Creado} \longrightarrow \text{Cola de Eventos} \longrightarrow \begin{cases} \text{Notificaciones (envío de correos y SMS de confirmación)} \\ \text{Inventario (descuento físico de existencias en almacén)} \end{cases}$$

### Controles de Seguridad en la Mensajería
1. **Canal Privado y Autenticación IAM:** La comunicación hacia SQS transita exclusivamente a través de un *VPC Endpoint* privado (`com.amazonaws.us-east-1.sqs`) bajo TLS 1.3, aplicando la condición `aws:SourceVpce`. Productores y consumidores se autentican con identidades efímeras gestionadas por **IAM Roles for Service Accounts (IRSA)**.
2. **Mínimo Privilegio en Colas (*Queue Policies*):** El microservicio de Pedidos únicamente dispone de permisos de publicación (`sqs:SendMessage`), mientras que Notificaciones e Inventario solo pueden consumir y purgar mensajes procesados (`sqs:ReceiveMessage`, `sqs:DeleteMessage`). Ningún servicio consumidor tiene privilegios para emitir eventos.
3. **Cifrado en Reposo y Firmas de Integridad:** Los mensajes almacenados en la cola se cifran automáticamente mediante **AWS KMS (SSE-KMS)**. En eventos transaccionales críticos (`PedidoPagado`), el productor genera una firma digital con **ECDSA P-256 en AWS KMS**; los consumidores validan esta firma asimétrica antes de ejecutar acciones en almacén.

### Modelo de Amenazas y Prevención de Inyección de Eventos
La mensajería asíncrona exige mitigar el riesgo de inyección de eventos fraudulentos, ya que la inserción de mensajes ilegítimos desencadenaría impactos críticos en el negocio:
- **Despachos fraudulentos no cobrados:** Mensajes apócrifos de confirmación de pago inducirían al almacén a preparar y enviar mercancía sin haber capturado los fondos en Stripe.
- **Inconsistencia de inventario y sobreventa (*overselling*):** Eventos manipulados de compra o cancelación desfasarían las existencias reales, provocando la venta de artículos agotados y generando penalizaciones regulatorias.
- **Denegación de servicio en proveedores externos:** La inyección masiva de eventos agotaría el presupuesto de APIs de mensajería (Twilio/SES) y afectaría la reputación del dominio corporativo al caer en listas negras de spam (*blacklisting*).

El aislamiento por VPC Endpoint, la estricta segregación de políticas IAM y la firma asimétrica de eventos garantizan que únicamente se procesen transacciones auténticas generadas por el servicio de Pedidos.
