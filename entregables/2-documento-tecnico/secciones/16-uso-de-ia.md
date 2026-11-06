# 16. Uso de Inteligencia Artificial en Seguridad

ReMarket evalúa la IA como vector de amenaza y como evaluador para auditar el diseño, contrastando cada sugerencia frente a la viabilidad operativa en la nube.

### 16.1 La IA como Vector de Amenaza (Escenarios de Ataque)
1. **Spear-Phishing a Soporte:** *Activo:* Consolas AWS. *Vulnerabilidad:* Factor humano. *Impacto:* Secuestro de accesos cloud. *Aporte IA:* Suplantación contextual a escala. *Defensa:* MFA FIDO2 (llaves WebAuthn) resistente a MitM y CloudTrail.
2. **Descubrimiento de Fallas BOLA:** *Activo:* Endpoints (`POST /pedido`). *Vulnerabilidad:* Broken Object Level Authorization. *Impacto:* Exfiltración de pedidos ajenos. *Aporte IA:* Fuzzing semántico autónomo. *Defensa:* Validación OpenAPI en gateway, JWT contextual (`sub == cliente_id`) y alertas SIEM.
3. **Búsqueda Automatizada de Secretos:** *Activo:* Claves Stripe e IAM. *Vulnerabilidad:* Fuga accidental en código. *Impacto:* Control de infraestructura. *Aporte IA:* Detección semántica superando regex. *Defensa:* Gitleaks pre-commit, TruffleHog en CI, roles efímeros OIDC y GuardDuty.

### 16.2 La IA como Evaluador de Seguridad (Análisis Crítico)
Revisamos la arquitectura con un LLM en rol de auditor cloud (evidencia en el **Entregable 5**):

| Obs. | Sugerencia IA | Decisión | Análisis Crítico y Control Técnico Incorporado |
| :---: | :--- | :---: | :--- |
| **1** | mTLS en SQS/Kafka | **Modificada** | **Inexacta:** SQS es un servicio gestionado fuera de Istio; opera con TLS y **SigV4**. Se adaptó con *Queue Policies* (`aws:SourceVpce`) y **firmas ECDSA P-256 en KMS** para `PedidoPagado`. |
| **2** | FHE en backend para tarjetas | **Modificada** | **Inviable:** El cómputo homomórfico es $10^4$ veces más lento y choca con PCI SAQ-A (no debemos recibir tarjetas). Se movió la defensa al frontend con CSP estricta y SRI contra scripts maliciosos. |
| **3** | Claves AES en navegador (E2EE) | **Rechazada** | **Innecesaria:** ReMarket emite el comprobante (no es intermediario). Mandar llaves a JavaScript abre un hueco enorme a ataques XSS. Se protege con TLS 1.3, firmas PKI y control de permisos en el gateway. |

### 16.3 Valoración Crítica del Evaluador Automatizado
La IA tuvo fallas claras: recomendó protocolos incompatibles con servicios de AWS (mTLS en SQS), criptografía teórica demasiado pesada (FHE) y consejos que debilitaban al cliente (mandar llaves a JS). La IA sirve como copiloto para lluvia de ideas, pero la arquitectura exige siempre el criterio y la revisión técnica del ingeniero.
