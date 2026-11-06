# Entregable 1 — Diagrama de Arquitectura Cloud Segura

> **Estado:** Listo

## Descripción General

El diagrama de arquitectura de **ReMarket** representa una infraestructura cloud moderna, resiliente y distribuida bajo el paradigma **Zero Trust** y principios de **Security by Design**.

La arquitectura está particionada en **6 Zonas de Confianza** claramente delimitadas por controles perimetrales, criptográficos y de red:

1. **Z0 — Zona No Confiable (Internet Pública):** Clientes finales (web/móvil) y personal de operaciones conectándose desde redes no controladas.
2. **Z1 — Zona Perimetral (DMZ):** Servicios de borde que absorben tráfico masivo y filtran ataques antes de tocar la red privada:
   - **Amazon CloudFront (CDN):** Terminación TLS perimetral y almacenamiento en caché estático.
   - **AWS WAF + AWS Shield:** Mitigación de ataques DDoS volumétricos (L3/L4) y reglas L7 contra inyecciones SQL, XSS, rate-limiting contra bots y credential stuffing.
   - **Application Load Balancer (ALB):** Balanceo de carga hacia el API Gateway.
   - **Frontend Web:** Alojado como Single Page Application (SPA) estática en Amazon S3.
   - **API Gateway (Envoy Ingress):** Enrutador perimetral que valida tokens JWT iniciales y aplica cuotas.
   - **AWS Client VPN con MFA:** Acceso administrativo autenticado mediante certificados y doble factor.
3. **Z2 — Zona de Aplicación (Red Privada - Amazon EKS):** Clúster de Kubernetes en subredes privadas. La comunicación este-oeste está gobernada por **Istio Service Mesh**, forzando **mTLS estricto** con identidades SPIFFE/SPIRE y certificados X.509 efímeros:
   - Auth y Usuarios, Catálogo, Pedidos, Inventario, Pagos, Notificaciones.
   - **Amazon ElastiCache Redis:** Caché privada con autenticación y cifrado TLS.
   - **Bus de Eventos (Amazon SQS / Kafka):** Cola asíncrona con cifrado SSE-KMS y firma de mensajes.
4. **Z3 — Zona de Datos (Subredes Aisladas sin Internet):**
   - **Amazon RDS PostgreSQL Multi-AZ:** Base de datos relacional para transacciones críticas (pedidos, pagos y stock).
   - **Amazon RDS PostgreSQL (Usuarios):** Aislamiento físico/lógico para datos personales y hashes de credenciales.
   - **Amazon DynamoDB / S3:** Almacenamiento no relacional y multimedia para catálogo.
   - **Amazon S3 Object Lock (WORM):** Bitácora inmutable de auditoría para trazabilidad legal y forense.
5. **Z4 — Servicios de Seguridad y Gobernanza:**
   - **AWS KMS / CloudHSM (FIPS 140-2 Nivel 3):** Custodia de claves maestras (KEKs), firmas digitales y rotación.
   - **AWS Secrets Manager:** Gestión e inyección en runtime de secretos operacionales mediante External Secrets Operator.
   - **AWS IAM con IRSA:** Asignación de roles de mínimo privilegio vinculados a service accounts de Kubernetes.
   - **Amazon OpenSearch / SIEM:** Ingestión de eventos de seguridad (CloudTrail, VPC Flow Logs, Envoy access logs).
6. **Z5 — Terceros Confiables (APIs Externas):**
   - **Pasarela de Pagos (Stripe):** Tokenización del lado del cliente (PCI-DSS SAQ-A). ReMarket nunca almacena ni procesa PAN o CVV.
   - **APIs de Paquetería (DHL/FedEx):** Enlace HTTPS seguro con credenciales rotadas.
   - **Proveedor de Notificaciones (Twilio / Amazon SES):** Salida autenticada para envío de correos y SMS.

---

## Archivo fuente Mermaid

El código fuente vive en [](arquitectura.mmd).
