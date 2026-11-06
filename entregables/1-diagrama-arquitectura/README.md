# Entregable 1 — Diagrama de Arquitectura Cloud Segura

> **Estado:** Listo

## Descripción General

El diagrama de arquitectura de **ReMarket** representa una infraestructura cloud moderna, resiliente y distribuida bajo el paradigma **Zero Trust** y principios de **Security by Design**.

La arquitectura está particionada en **6 Zonas de Confianza** claramente delimitadas por controles perimetrales, criptográficos y de red:

1. **Z0 — Zona No Confiable (Internet Pública):** Clientes finales (navegador web) y personal de operaciones conectándose desde redes no controladas.
2. **Z1 — Zona Perimetral (DMZ):** Servicios de borde que absorben tráfico masivo y filtran ataques antes de tocar la red privada:
   - **Amazon CloudFront (CDN):** Terminación TLS perimetral y almacenamiento en caché estático. Sirve la SPA desde S3 (origen privado con OAC) y reenvía las llamadas a la API al ALB re-cifrando con TLS.
   - **AWS WAF (L7) + AWS Shield (L3/L4):** Shield absorbe los ataques DDoS volumétricos; WAF aplica reglas L7 contra inyecciones SQL, XSS, bots y credential stuffing, y rate limiting.
   - **Application Load Balancer (ALB):** Balanceo de carga multi-AZ con health checks hacia el API Gateway.
   - **Frontend Web:** Single Page Application (SPA) estática en Amazon S3, accesible sólo a través de CloudFront.
   - **API Gateway (Istio Ingress Gateway / Envoy):** Punto de entrada único que valida JWT y esquemas OpenAPI, aplica cuotas y abre mTLS hacia los microservicios. También recibe el webhook de Stripe: ningún pod tiene IP pública.
   - **AWS Client VPN con MFA:** Acceso administrativo autenticado mediante certificados y doble factor.
3. **Z2 — Zona de Aplicación (Red Privada - Amazon EKS):** Clúster de Kubernetes en subredes privadas. La comunicación este-oeste está gobernada por **Istio Service Mesh**, forzando **mTLS estricto** con identidades SPIFFE y certificados X.509 de 24 h emitidos por la CA de Istio (istiod):
   - Auth y Usuarios, Catálogo, Pedidos, Inventario, Pagos, Notificaciones.
   - **Amazon ElastiCache Redis:** Caché privada con autenticación y cifrado TLS.
   - **Bus de Eventos (Amazon SNS → SQS):** Tema SNS con una cola SQS por consumidor (fan-out), cifrado SSE-KMS, colas de mensajes fallidos (DLQ) y firma ECDSA del evento crítico `PedidoPagado`.
4. **Z3 — Zona de Datos (Subredes Aisladas sin Internet):**
   - **Amazon RDS PostgreSQL Multi-AZ:** Base de datos transaccional con un esquema y un usuario de BD por servicio (pedidos, pagos, inventario): ningún servicio puede leer las tablas de otro.
   - **Amazon RDS PostgreSQL (Usuarios):** Aislamiento físico/lógico para datos personales y hashes de credenciales.
   - **Amazon DynamoDB / S3:** Almacenamiento no relacional y multimedia para catálogo.
   - **Amazon S3 Object Lock (WORM):** Bitácora inmutable de auditoría para trazabilidad legal y forense.
5. **Z4 — Servicios de Seguridad y Gobernanza:**
   - **AWS KMS:** Claves maestras (KEKs) del cifrado de sobre y clave de firma de eventos; rotación automática.
   - **AWS CloudHSM:** Llave privada de firma de comprobantes y facturas, no exportable.
   - **AWS Secrets Manager:** Gestión e inyección en runtime de secretos operacionales mediante External Secrets Operator.
   - **AWS IAM con IRSA:** Asignación de roles de mínimo privilegio vinculados a service accounts de Kubernetes.
   - **CA de Istio (istiod):** Emite y rota los certificados SPIFFE de cada pod.
   - **Amazon OpenSearch / SIEM:** Ingestión de eventos de seguridad (CloudTrail, VPC Flow Logs, Envoy access logs).
6. **Z5 — Terceros Confiables (APIs Externas):**
   - **Pasarela de Pagos (Stripe):** Tokenización del lado del cliente (PCI-DSS SAQ-A). ReMarket nunca almacena ni procesa PAN o CVV.
   - **APIs de Paquetería (DHL/FedEx):** Enlace HTTPS seguro con credenciales rotadas.
   - **Proveedor de Notificaciones (Twilio / Amazon SES):** Salida autenticada para envío de correos y SMS.

---

## Archivo fuente Mermaid

El código fuente vive en [`arquitectura.mmd`](arquitectura.mmd). Para regenerar el PNG y el SVG (y copiarlos al documento técnico) ejecuta `./exportar.sh`.
