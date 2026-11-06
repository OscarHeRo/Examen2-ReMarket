# 1. Arquitectura General del Sistema

ReMarket opera sobre **AWS EKS** (Kubernetes) con **Istio Service Mesh**, estructurada en **6 Zonas de Confianza**:

- **Z0 (No Confiable):** Navegadores de clientes y equipos del personal interno.
- **Z1 (Perimetral - DMZ):** CloudFront, AWS WAF (filtrado L7) y AWS Shield (DDoS L3/L4), ALB, Istio Ingress Gateway, SPA en S3 y VPN administrativa.
- **Z2 (Aplicación EKS):** Microservicios privados (Auth, Catálogo, Pedidos, Inventario, Pagos, Notificaciones), Redis y el bus SNS → SQS.
- **Z3 (Persistencia Aislada):** Subredes sin salida a Internet: RDS PostgreSQL de usuarios, RDS transaccional Multi-AZ, DynamoDB y bitácoras en S3.
- **Z4 (Gestión y Seguridad):** AWS KMS, CloudHSM, Secrets Manager, IAM (IRSA), CA de Istio y SIEM.
- **Z5 (Servicios Externos):** Proveedores vía HTTPS: Stripe (pagos SAQ-A), paqueterías (DHL/FedEx) y mensajería (Twilio/SES).

| Componente | Implementación | Zona | Función y Control de Seguridad |
| :--- | :--- | :---: | :--- |
| **Frontend web** | SPA en S3 servida por CloudFront | Z1 | Distribución estática con CSP y HSTS Preload. |
| **API Gateway** | Istio Ingress Gateway (Envoy) tras ALB | Z1 | Entrada única, validación JWT/OpenAPI y rate limiting. |
| **Auth y Usuarios** | Pods en EKS privado | Z2 | Emisión de JWT (ES256) y contraseñas con Argon2id. |
| **Catálogo** | Pods en EKS privado | Z2 | Lecturas desacopladas de persistencia transaccional. |
| **Pedidos** | Pods en EKS privado | Z2 | Orquestación, idempotencia en Redis y firma de comprobantes. |
| **Inventario** | Pods en EKS privado | Z2 | Reserva atómica de existencias contra *overselling*. |
| **Pagos** | Pods en EKS privado | Z2 | Coordinación con Stripe y validación HMAC de webhooks. |
| **Notificaciones** | Pods en EKS privado | Z2 | Consumo asíncrono y envío de correos/SMS. |
| **BD Usuarios** | RDS PostgreSQL | Z3 | Datos personales y hashes; sólo accesible por Auth. |
| **BD Transaccional** | RDS PostgreSQL Multi-AZ | Z3 | Un esquema y usuario de BD por servicio; réplica síncrona. |
| **BD Catálogo** | Amazon DynamoDB + S3 | Z3 | NoSQL para lecturas con cifrado KMS transparente. |
| **Caché** | ElastiCache Redis | Z2 | Sesiones de refresco y llaves de idempotencia (TTL 24 h). |
| **Bus de eventos** | Amazon SNS → SQS | Z2 | Fan-out a una cola por consumidor, permisos IAM y firma ECDSA. |
| **Ext. Pagos** | Stripe API | Z5 | Tokenización; ReMarket no toca tarjetas (PCI SAQ-A). |
| **Ext. Paquetería** | APIs DHL / FedEx | Z5 | Envíos vía TLS autenticados con tokens API rotados. |

### Aislamiento de Red
La segmentación en zonas impide el movimiento lateral: los pods no tienen IP pública y todo lo que entra (incluido el webhook de Stripe) pasa por CloudFront, WAF, ALB y el Ingress Gateway. Si un servicio expuesto como Catálogo es comprometido, las reglas de red y las políticas IAM impiden cualquier conexión hacia las bases de datos de usuarios o pagos (detalle en la sección 13). El diagrama completo está en el **Anexo A** al final del documento.
