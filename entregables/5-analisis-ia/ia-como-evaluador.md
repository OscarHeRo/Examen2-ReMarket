# IA como Evaluador de Seguridad

> **Responsable:** Equipo (Oscar, Ian, Violeta) · **Estado:** Listo

Se presentó un resumen de la arquitectura de **ReMarket** a una IA para que encontrara riesgos, errores de diseño o controles faltantes, y evaluamos críticamente sus tres observaciones. El prompt describe la **versión inicial** del diseño (por eso aún menciona SPIRE y "SQS/Kafka"); los cambios que salieron de esta revisión ya están aplicados en el documento técnico.

---

## Paso 1 — El Prompt Utilizado

```text
Actúa como un Auditor Senior de Ciberseguridad Cloud y Criptografía Aplicada.
Evalúa el siguiente diseño de arquitectura de comercio electrónico (ReMarket):
- Microservicios en Amazon EKS con Istio Service Mesh, mTLS interno y certificados SPIFFE/SPIRE efímeros (24h).
- Perímetro protegido por Amazon CloudFront (CDN), AWS WAF y AWS Shield con TLS 1.3 (ECDHE-X25519) y HSTS Preload.
- API REST con JWT firmados en ES256 y llaves de idempotencia en ElastiCache Redis para POST /pedido.
- Datos en reposo protegidos con AES-256-GCM y Envelope Encryption mediante AWS KMS y CloudHSM (FIPS 140-2 L3).
- Contraseñas almacenadas exclusivamente con Argon2id (m=64MB, t=3, p=4) y salt CSPRNG único de 16 bytes.
- Pasarela de pagos integrada vía tokenización en el cliente con Stripe Elements (PCI-DSS SAQ-A), sin almacenamiento de PAN/CVV en ReMarket. Webhooks de pago validados con firma HMAC-SHA256 y ventana anti-replay de 300 segundos.
- Facturas digitales firmadas con hash SHA-256 y ECDSA P-256 con certificado público X.509.
- Bus de eventos asíncrono en Amazon SQS/Kafka con cifrado SSE-KMS y políticas de mínimo privilegio IAM.
- Pipeline DevSecOps con pre-commit Gitleaks, SAST SonarQube, SCA Trivy/Snyk, firma de imágenes OCI con Sigstore Cosign y despliegue GitOps con ArgoCD.

Identifica al menos tres observaciones técnicas: posibles vulnerabilidades no cubiertas, riesgos de implementación o mejoras de endurecimiento criptográfico.
```

- **Herramienta:** Claude (Anthropic), usado a través de Claude Code
- **Fecha de consulta:** 6 de noviembre de 2026
- **Respuesta completa:** [`evidencia/01-revision-arquitectura.md`](evidencia/01-revision-arquitectura.md)

---

## Paso 2 — Evaluación Crítica de las Observaciones

### Observación 1 — Autenticidad de los eventos en el bus

> *"Si un servicio con permiso de publicación es comprometido, puede inyectar un `PedidoPagado` falso y provocar un despacho sin cobro. Recomiendo: (a) separar temas o colas por tipo de evento y dar permiso de publicación sólo al servicio dueño de cada uno; (b) firmar los eventos críticos con una clave asimétrica de KMS y verificar la firma en el consumidor; (c) consumidores idempotentes y una cola de mensajes fallidos (DLQ)."*

| Pregunta | Evaluación Crítica del Equipo |
| :--- | :--- |
| **1. ¿Es técnicamente correcta?** | **Sí.** SSE-KMS protege el dato guardado, no su origen, y una política que permite `Publish` no restringe el tipo de evento. |
| **2. ¿Aplica a nuestra arquitectura?** | **Sí.** Pedidos y Pagos publican en el mismo bus, e Inventario actúa sobre `PedidoPagado`. |
| **3. ¿Qué riesgo intenta reducir?** | Inyección de eventos falsos y despachos sin cobro (R6). |
| **4. ¿La aceptamos, modificamos o rechazamos?** | **Modificada.** |
| **5. ¿Qué evidencia técnica justifica la decisión?** | Adoptamos (b) y (c): `PedidoPagado` lo publica y firma sólo Pagos con una clave ECDSA P-256 de KMS que ningún otro rol puede usar, y los consumidores la verifican; consumidores idempotentes y DLQ. En lugar de (a), mantenemos un solo tema SNS: la firma ya impide que Pedidos falsifique un pago, y separar temas añade operación sin reducir más el riesgo. Descartamos Kafka y nos quedamos con SNS → SQS, así que la parte de mTLS en MSK no aplica. |

**Dónde queda reflejada:** Sección 11, diagrama de arquitectura y riesgo R6.

---

### Observación 2 — La ventana de 300 s no basta contra la repetición de webhooks

> *"Dentro de esos 5 minutos el mismo evento firmado puede llegar varias veces (Stripe incluso reintenta de forma legítima). Registren el `event.id` ya procesado e ignoren los repetidos. Además, antes de despachar, consulten el `PaymentIntent` en la API de Stripe y comparen monto y moneda con el pedido."*

| Pregunta | Evaluación Crítica del Equipo |
| :--- | :--- |
| **1. ¿Es técnicamente correcta?** | **Sí.** La marca de tiempo limita *cuándo* se acepta un mensaje, no *cuántas veces*. La documentación de Stripe indica que un mismo evento puede entregarse más de una vez. |
| **2. ¿Aplica a nuestra arquitectura?** | **Sí.** Nuestro diseño sólo tenía firma + ventana. |
| **3. ¿Qué riesgo intenta reducir?** | Procesar dos veces un pago o confirmar un pedido con el pago de otro (R6). |
| **4. ¿La aceptamos, modificamos o rechazamos?** | **Aceptada.** |
| **5. ¿Qué evidencia técnica justifica la decisión?** | Guardar el `event.id` cuesta una escritura en Redis o en la BD por webhook. Comparar monto y moneda cierra el caso en que un pago real, pero de otro pedido o por menos dinero, se usa para confirmar una orden. |

**Dónde queda reflejada:** Sección 9 (cuatro verificaciones del webhook) y matriz de riesgos (R6).

---

### Observación 3 — Dónde guarda el navegador los JWT

> *"Si se guardan en `localStorage`, cualquier XSS puede leerlos y reutilizarlos desde otra máquina durante toda su vigencia. Recomiendo guardar la sesión en una cookie `HttpOnly; Secure; SameSite=Strict`, o bien mantener el token de acceso sólo en memoria con vida corta y el de refresco en una cookie `HttpOnly` con rotación en cada uso."*

| Pregunta | Evaluación Crítica del Equipo |
| :--- | :--- |
| **1. ¿Es técnicamente correcta?** | **Sí.** JavaScript inyectado puede leer `localStorage`, pero no una cookie `HttpOnly`. |
| **2. ¿Aplica a nuestra arquitectura?** | **Sí, y además mostró una inconsistencia nuestra:** la clasificación de información decía "cookie" y la API decía `Authorization: Bearer`. |
| **3. ¿Qué riesgo intenta reducir?** | Robo de tokens de sesión mediante XSS (secuestro de sesión). |
| **4. ¿La aceptamos, modificamos o rechazamos?** | **Modificada.** |
| **5. ¿Qué evidencia técnica justifica la decisión?** | Elegimos la segunda opción: token de acceso de 15 min sólo en memoria, enviado como `Bearer`, y token de refresco en cookie `HttpOnly; Secure; SameSite=Strict` que rota en cada uso. Así la API sigue sin depender de cookies para cada petición (menos exposición a CSRF) y un XSS no puede llevarse una sesión duradera. La CSP estricta reduce además la probabilidad del XSS. |

**Dónde queda reflejada:** Sección 2 (tokens de sesión) y sección 5 (`POST /pedido`).

---

## Paso 3 — Decisión Final del Equipo

| Observación Evaluada | Decisión Final | Cambio en el Proyecto |
| :---: | :---: | :--- |
| **1. Autenticidad de eventos en el bus** | **Modificada** | Firma ECDSA de `PedidoPagado` sólo por Pagos, idempotencia y DLQ; un solo tema SNS; Kafka descartado (sección 11). |
| **2. Repetición de webhooks** | **Aceptada** | Registro de `event.id` y comparación de monto y moneda con Stripe (sección 9). |
| **3. Almacenamiento de JWT** | **Modificada** | Acceso en memoria + refresco en cookie `HttpOnly` con rotación (secciones 2 y 5). |

**Lo que la respuesta no cubrió:** no señaló que el prompt mezclaba dos opciones distintas
(la CA de Istio y SPIRE), y como el prompt no incluía el diagrama, tampoco pudo ver que el
webhook entraba directo a un pod privado. Esos errores aparecieron al comparar el diagrama
con el texto: una IA sólo evalúa lo que se le muestra.
