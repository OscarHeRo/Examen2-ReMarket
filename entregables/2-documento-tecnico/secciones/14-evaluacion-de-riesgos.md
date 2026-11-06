# 14. Evaluación y Gestión de Riesgos

Priorizamos la inversión en seguridad evaluando los riesgos del sistema mediante una matriz cuantitativa:

$$\text{Nivel de Riesgo} = \text{Impacto } (1 \text{ a } 3) \times \text{Probabilidad } (1 \text{ a } 3)$$

Rangos: **6–9 (Alto)**, **3–4 (Medio)** y **1–2 (Bajo)**. A continuación se presentan los riesgos identificados para la plataforma de ReMarket:

| ID | Categoría | Amenaza | $I$ | $P$ | Nivel | Tratamiento |
| :---: | :--- | :--- | :---: | :---: | :---: | :--- |
| **R1** | **Credenciales** | Fuga de API keys maestras en repositorios Git. | 3 | 2 | **6 (Alto)** | **Mitigar:** Gitleaks pre-commit, OIDC y Secrets Manager. |
| **R2** | **Comunicaciones** | Espionaje MitM en tráfico este-oeste entre pods. | 3 | 2 | **6 (Alto)** | **Mitigar:** mTLS estricto con Istio y certificados SPIRE. |
| **R3** | **Almacenamiento** | Fuga de respaldos de base de datos sin cifrar. | 3 | 2 | **6 (Alto)** | **Mitigar:** AES-256 en KMS e inmutabilidad S3 WORM. |
| **R4** | **Disponibilidad** | Caída por ataque DDoS masivo en temporada alta. | 3 | 3 | **9 (Alto)** | **Mitigar:** CloudFront CDN, AWS Shield y WAF rate limiting. |
| **R5** | **Cadena Suministro** | Dependencias de terceros con fallas críticas (CVE $\ge 7.0$). | 3 | 2 | **6 (Alto)** | **Mitigar:** Análisis SCA bloqueante en CI y firmas Cosign. |
| **R6** | **Terceros / Pagos** | Envío de webhooks falsos para simular pagos aprobados. | 3 | 2 | **6 (Alto)** | **Mitigar:** HMAC-SHA256 y verificación out-of-band con Stripe. |

### Tratamiento de Riesgos Prioritarios
| Riesgo | Control Preventivo | Control Detectivo | Control Correctivo |
| :--- | :--- | :--- | :--- |
| **R1 (Credenciales)** | Gitleaks pre-commit y OIDC sin secretos en Git. | TruffleHog en CI y alarmas CloudTrail por llamadas inusuales. | Revocación y rotación en Secrets Manager. |
| **R4 (DDoS)** | CloudFront CDN y reglas WAF (500 req/min). | Alarmas CloudWatch por latencia o errores 5xx. | AWS Shield automático y autoescalado Karpenter. |
| **R6 (Webhooks Falsos)** | HMAC-SHA256 con comparación en tiempo constante. | Registro SIEM de firmas inválidas o $t > 300\text{ s}$. | Bloqueo en WAF y consulta out-of-band a Stripe. |
