# 16. Uso de Inteligencia Artificial en Seguridad

Analizamos la IA desde dos lados: como herramienta del atacante y como evaluador de nuestro diseño. El detalle completo está en el Entregable 5.

### 16.1 La IA como Atacante

| Escenario | Activo | Debilidad | Impacto | Controles de ReMarket | Evidencia para detectarlo |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Phishing dirigido a soporte** (la IA redacta correos personalizados a escala) | Cuentas del personal y consola AWS | Factor humano | Acceso a datos de clientes y a la nube | MFA FIDO2 resistente a phishing, VPN y roles temporales | Inicios de sesión desde IP o país inusual (GuardDuty, CloudTrail) |
| **Búsqueda automática de fallas BOLA** (la IA infiere la API y genera peticiones válidas) | Pedidos y perfiles de clientes | Autorización por objeto mal implementada | Fuga masiva de pedidos y direcciones | Cliente tomado del `sub` del JWT, validación OpenAPI, rate limiting | Ráfagas de 403/404 con IDs secuenciales desde una sesión (SIEM) |
| **Búsqueda de secretos filtrados** (la IA detecta claves ofuscadas que escapan a regex) | Llaves de Stripe y AWS | Secretos en código o historial de Git | Cobros fraudulentos y control de la nube | Gitleaks en pre-commit y CI, OIDC, Secrets Manager | Alertas de *secret scanning* y uso de credenciales desde IPs nuevas (CloudTrail) |

### 16.2 La IA como Evaluador

Le pedimos a una IA (Claude, de Anthropic) que auditara un resumen de la arquitectura. Prompt (resumido): *"Actúa como un Auditor Senior de Ciberseguridad Cloud… Evalúa el siguiente diseño… Identifica al menos tres observaciones técnicas"*. Prompt y respuesta completos en `entregables/5-analisis-ia/evidencia/`.

| Obs. | Fragmento de la respuesta | ¿Correcta? ¿Aplica? | Riesgo que reduce | Decisión y evidencia |
| :---: | :--- | :--- | :--- | :--- |
| **1** | *"Si un servicio con permiso de publicación es comprometido, puede inyectar un `PedidoPagado` falso…"* | Sí y sí: SSE-KMS no prueba el origen del evento | Eventos falsos, despachos sin cobro | **Modificada:** firmamos sólo `PedidoPagado` con KMS en vez de separar temas; Kafka descartado (sec. 11) |
| **2** | *"Dentro de esos 5 minutos el mismo evento firmado puede llegar varias veces… Registren el `event.id`"* | Sí y sí: la ventana limita *cuándo*, no *cuántas veces* | Pagos procesados dos veces | **Aceptada:** registro de `event.id` y verificación de monto con Stripe (sec. 9) |
| **3** | *"Si se guardan en `localStorage`, cualquier XSS puede leerlos…"* | Sí, y exhibió una inconsistencia nuestra (cookie vs. Bearer) | Robo de sesión por XSS | **Modificada:** acceso en memoria y refresco en cookie `HttpOnly` (secs. 2 y 5) |

### 16.3 Valoración Crítica
Las tres observaciones fueron correctas, pero dos se ajustaron a nuestro sistema antes de aplicarlas, y la IA no vio errores que no estaban en el texto que le dimos (el webhook dibujado directo a un pod privado).
