# 1. Arquitectura General del Sistema

ReMarket opera sobre **AWS EKS** (Kubernetes) con **Istio Service Mesh**, estructurada en **6 Zonas de Confianza**:

- **Z0 (No Confiable):** Navegadores y aplicaciones móviles de clientes.
- **Z1 (Perimetral - DMZ):** CloudFront CDN, AWS WAF (mitigación DDoS L3-L7), API Gateway y SPA en S3.
- **Z2 (Aplicación EKS):** Microservicios privados (Auth, Catálogo, Pedidos, Inventario, Pagos, Notificaciones), Redis y SQS.
- **Z3 (Persistencia Aislada):** Subredes no enrutables: RDS PostgreSQL Multi-AZ, DynamoDB y respaldos S3.
- **Z4 (Gestión y Seguridad):** AWS KMS / CloudHSM (FIPS 140-2 L3), Secrets Manager e IAM (IRSA).
- **Z5 (Servicios Externos):** Proveedores vía HTTPS: Stripe (pagos SAQ-A), paqueterías (DHL) y mensajería (Twilio).

| Componente | Implementación | Zona | Función y Control de Seguridad |
| :--- | :--- | :---: | :--- |
| **Frontend web** | SPA en S3 + CloudFront | Z1 | Distribución estática con CSP y HSTS Preload. |
| **API Gateway** | AWS API Gateway / Envoy | Z1 | Entrada única, validación OpenAPI y rate limiting. |
| **Auth y Usuarios** | Pods en EKS privado | Z2 | Emisión de JWT (ES256) y contraseñas con Argon2id. |
| **Catálogo** | Pods en EKS privado | Z2 | Lecturas desacopladas de persistencia transaccional. |
| **Pedidos** | Pods en EKS privado | Z2 | Orquestación transaccional e idempotencia en Redis. |
| **Inventario** | Pods en EKS privado | Z2 | Bloqueo atómico de existencias contra *overselling*. |
| **Pagos** | Pods en EKS privado | Z2 | Coordinación con Stripe y validación HMAC de webhooks. |
| **Notificaciones** | Pods en EKS privado | Z2 | Consumo asíncrono y envío de correos/SMS. |
| **BD Transaccional** | RDS PostgreSQL Multi-AZ | Z3 | Persistencia ACID cifrada (AES-256) con réplica síncrona. |
| **BD Catálogo** | Amazon DynamoDB | Z3 | NoSQL para lecturas con cifrado KMS transparente. |
| **Caché** | ElastiCache Redis | Z2 | Sesiones temporales y llaves de idempotencia (TTL 120s). |
| **Cola / Bus eventos** | Amazon SQS / Kafka | Z2 | Bus desacoplado con control IAM y firmas ECDSA. |
| **Ext. Pagos** | Stripe API | Z5 | Tokenización; ReMarket no toca tarjetas (PCI SAQ-A). |
| **Ext. Paquetería** | APIs DHL / FedEx | Z5 | Envíos vía TLS 1.3 autenticados con tokens API. |

### Aislamiento de Red
La segmentación en zonas impide el movimiento lateral: los pods no tienen IP pública y solo acceden a persistencia mediante VPC Endpoints privados. Si un servicio perimetral (catálogo) es comprometido, las reglas de red y políticas IAM impiden cualquier conexión hacia las bases de datos de usuarios o pagos.

![Diagrama de Arquitectura Cloud Segura de ReMarket](imagenes/arquitectura.png)
