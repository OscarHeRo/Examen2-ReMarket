# IA como Evaluador de Seguridad

> **Responsable:** Equipo (Oscar, Ian, Violeta) · **Estado:** Listo

Se presentó el diseño completo de la arquitectura cloud de **ReMarket** a un modelo de IA avanzado para someterlo a escrutinio crítico y evaluar objetivamente tres de sus observaciones principales.

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

- **Herramienta y versión utilizada:** Claude 3.5 Sonnet / Gemini 1.5 Pro  
- **Fecha de consulta:** 5 de noviembre de 2026  

---

## Paso 2 — Evaluación Crítica de las Observaciones

### Observación 1 — "Implementar autenticación mutua (mTLS) y autorización estricta en el broker de mensajería asíncrona, no solo en las APIs REST"

> *"Aunque el bus de eventos (Kafka/SQS) reside en subredes privadas, confiar únicamente en el cifrado en reposo SSE-KMS deja expuesto el canal en tránsito interno. Un atacante que comprometa un pod consumidor de menor criticidad (p. ej. Notificaciones) podría actuar como productor espurio e inyectar eventos falsos de órdenes pagadas o leer cargas sensibles en tránsito."*

| Pregunta | Evaluación Crítica del Equipo |
| :--- | :--- |
| **1. ¿La recomendación es técnicamente correcta?** | **Inexacta.** Amazon SQS es un servicio gestionado multi-inquilino de AWS que opera fuera del service mesh de Istio; no soporta mTLS con identidades SPIRE. Opera bajo TLS y autenticación SigV4/IAM. |
| **2. ¿Aplica realmente a nuestra arquitectura?** | **Parcialmente.** ReMarket utiliza eventos asíncronos para actualizar inventario y despachar notificaciones, pero sobre SQS/Kafka gestionado en la nube. |
| **3. ¿Qué riesgo intenta reducir?** | Suplantación de productores, inyección de eventos falsos y escucha no autorizada en el bus de eventos (**R2 y R6**). |
| **4. ¿La aceptamos, modificamos o rechazamos?** | **Modificada**. |
| **5. ¿Qué evidencia técnica justifica la decisión?** | No se puede forzar mTLS en SQS nativo. La solución real en AWS consiste en restringir el acceso a un *VPC Endpoint* privado con la condición `aws:SourceVpce`, aplicar *Queue Policies* IAM estrictas (IRSA) por servicio y firmar digitalmente eventos críticos (`PedidoPagado`) con **ECDSA P-256 en AWS KMS**, permitiendo a los consumidores validar la firma con la clave pública sin que puedan emitir mensajes apócrifos. |

**Dónde queda reflejada:** Sección 11 del documento técnico y en el diagrama de arquitectura (flujo entre Pedidos y Bus).

---

### Observación 2 — "Utilizar Cifrado Homomórfico para procesar datos de tarjetas de crédito en memoria sin descifrarlos jamás"

> *"Para evitar cualquier ventana de exposición en memoria RAM durante transacciones de pago, ReMarket debería implementar esquemas de cifrado totalmente homomórfico (FHE), permitiendo realizar operaciones aritméticas sobre los datos de tarjeta cifrados directamente en los microservicios."*

| Pregunta | Evaluación Crítica del Equipo |
| :--- | :--- |
| **1. ¿La recomendación es técnicamente correcta?** | **Parcialmente teórica.** Las matemáticas del cifrado homomórfico existen, pero su viabilidad práctica en e-commerce de alto rendimiento es nula. |
| **2. ¿Aplica realmente a nuestra arquitectura?** | **NO de forma directa.** ReMarket adopta el estándar PCI-DSS SAQ-A donde el PAN nunca llega al servidor. |
| **3. ¿Qué riesgo intenta reducir?** | Exposición de números de tarjeta en la memoria RAM del microservicio de pagos (**R1**). |
| **4. ¿La aceptamos, modificamos o rechazamos?** | **Modificada**. |
| **5. ¿Qué evidencia técnica justifica la decisión?** | El cifrado homomórfico introduce una sobrecarga computacional de hasta cuatro órdenes de magnitud ($10^4$), destruyendo los SLAs de latencia en picos de demanda. La solución óptima es mantener la **tokenización en el cliente mediante Stripe Elements**: ReMarket jamás recibe el PAN, logrando el mismo objetivo de confidencialidad con latencia despreciable. |

**Dónde queda reflejada:** Sección 09 del documento técnico y Sección 16.

---

### Observación 3 — "Entregar claves simétricas AES al navegador del cliente para descifrar localmente los comprobantes de compra"

> *"Para reducir la carga en los servidores y aplicar cifrado de extremo a extremo (E2EE), el servidor debería emitir claves simétricas AES derivadas que se envíen al navegador web del cliente, permitiendo que el descifrado de compras se realice localmente con la Web Cryptography API."*

| Pregunta | Evaluación Crítica del Equipo |
| :--- | :--- |
| **1. ¿La recomendación es técnicamente correcta?** | **NO.** Es un grave error de diseño criptográfico. |
| **2. ¿Aplica realmente a la arquitectura propuesta?** | **NO.** Viola el modelo de amenazas de aplicaciones web. |
| **3. ¿Qué riesgo intenta reducir?** | Carga de procesamiento en el clúster de Kubernetes. |
| **4. ¿La aceptamos, modificamos o rechazamos?** | **Rechazada Categóricamente**. |
| **5. ¿Qué evidencia técnica justifica la decisión?** | El navegador web es un entorno de confianza cero fuera del control corporativo. Enviar claves simétricas al cliente expone las llaves a robo mediante ataques Cross-Site Scripting (XSS), extensiones de navegador maliciosas o inspección directa en DevTools. La confidencialidad entre el cliente y el servidor se garantiza de manera segura y estándar mediante **TLS 1.3** sin comprometer material criptográfico maestro. |

**Dónde queda reflejada:** Sección 16 y Sección 17 (argumento central sobre los peligros de alucinaciones y sugerencias erróneas de la IA).

---

## Paso 3 — Decisión Final del Equipo

| Observación Evaluada | Decisión Final | Justificación y Cambio en el Proyecto |
| :---: | :---: | :--- |
| **1. mTLS y firmas en bus de eventos** | **Modificada** | Se descartó mTLS por incompatibilidad con SQS administrado y se incorporó canal privado por VPC Endpoint, políticas IAM estrictas y firmas asimétricas ECDSA P-256 en KMS (Sección 11). |
| **2. Cifrado homomórfico en pagos** | **Modificada** | Se descartó FHE por sobrecarga y se reforzó la tokenización cliente PCI-DSS SAQ-A en la sección 09. |
| **3. Claves simétricas en frontend** | **Rechazada** | Se rechazó por violar Zero Trust; se demostró que TLS 1.3 resuelve la confidencialidad sin exponer llaves. |
