# Evidencia de consulta a IA — 01: Revisión de la arquitectura

**Herramienta:** Claude (Anthropic), usado a través de Claude Code (claude.ai/code)
**Fecha:** 2026-11-06
**Quién la hizo:** Oscar David Hernández Rodríguez
**Para qué sección:** Entregable 5 (IA como evaluador) y sección 16 del documento técnico

---

## Prompt utilizado

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

## Respuesta de la IA (completa)

> **Observación 1 — Autenticidad de los eventos en el bus.** SSE-KMS sólo protege los
> mensajes mientras están guardados, y una política IAM de "mínimo privilegio" que permite
> publicar en la cola no distingue *qué* evento publica cada servicio. Si un servicio con
> permiso de publicación es comprometido, puede inyectar un `PedidoPagado` falso y provocar
> un despacho sin cobro. Recomiendo: (a) separar temas o colas por tipo de evento y dar
> permiso de publicación sólo al servicio dueño de cada uno; (b) firmar los eventos
> críticos con una clave asimétrica de KMS y verificar la firma en el consumidor;
> (c) consumidores idempotentes y una cola de mensajes fallidos (DLQ). Si usan Kafka (MSK)
> en lugar de SQS, habiliten autenticación de clientes con mTLS o IAM y ACLs por tópico.
>
> **Observación 2 — La ventana de 300 s no basta contra la repetición de webhooks.** La
> ventana impide reenviar notificaciones viejas, pero dentro de esos 5 minutos el mismo
> evento firmado puede llegar varias veces (Stripe incluso reintenta de forma legítima).
> Registren el `event.id` ya procesado e ignoren los repetidos. Además, antes de despachar,
> consulten el `PaymentIntent` en la API de Stripe y comparen monto y moneda con el pedido:
> una firma válida sólo prueba que el mensaje viene de Stripe, no que corresponde al pedido
> correcto.
>
> **Observación 3 — Dónde guarda el navegador los JWT.** El diseño no indica cómo almacena
> la SPA los tokens. Si se guardan en `localStorage`, cualquier XSS puede leerlos y
> reutilizarlos desde otra máquina durante toda su vigencia. Recomiendo guardar la sesión en
> una cookie `HttpOnly; Secure; SameSite=Strict`, o bien mantener el token de acceso sólo en
> memoria con vida corta y el de refresco en una cookie `HttpOnly` con rotación en cada uso.

## Análisis crítico del equipo

Las tres observaciones son técnicamente correctas y aplican a nuestro diseño. Las
evaluamos una por una en [`../ia-como-evaluador.md`](../ia-como-evaluador.md): la
observación 2 se aceptó tal cual y las observaciones 1 y 3 se modificaron para ajustarlas a
la arquitectura.

## Decisión final

🟨 Observación 1: Modificada · ✅ Observación 2: Aceptada · 🟨 Observación 3: Modificada

**Qué cambió en el proyecto:** secciones 5, 9, 11 y 16 del documento técnico, diagrama de
arquitectura (bus SNS → SQS, `PedidoPagado` publicado y firmado por Pagos) y riesgo R6 de
la matriz.
