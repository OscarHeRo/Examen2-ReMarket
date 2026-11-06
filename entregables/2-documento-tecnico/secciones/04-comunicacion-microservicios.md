# 4. Comunicación entre Microservicios

Bajo **Zero Trust**, la red interna de Kubernetes no se considera segura. El tráfico este-oeste pasa por **Istio Service Mesh** con proxies **Envoy**; la autenticación mutua se aplica según el tramo:

| Tramo de Comunicación | Mecanismo | ¿mTLS? | Justificación Técnica |
| :--- | :--- | :---: | :--- |
| **Gateway → Microservicios** | mTLS estricto + JWT | **SÍ** | El Ingress Gateway es parte del mesh: el servicio comprueba que la llamada venga del Gateway y no de otro pod. |
| **Microservicio → Microservicio** | mTLS estricto + JWT | **SÍ** | Evita suplantaciones y espionaje este-oeste si un pod es comprometido. |
| **Microservicio → Redis** | TLS + token AUTH por servicio | **NO** | ElastiCache no admite certificados de cliente: el servidor se autentica por TLS y el cliente con su token (rotado en Secrets Manager). |
| **Microservicio → RDS** | TLS + autenticación IAM | **NO** | RDS se autentica por TLS y el servicio con un token IAM temporal (IRSA, 15 min), sin contraseña fija. |
| **Microservicio → SNS/SQS y KMS** | TLS + firma SigV4 | **NO** | Servicios gestionados de AWS: cada petición va firmada con credenciales temporales del rol del servicio. |

En los tres últimos tramos **ambas partes sí se autentican**, pero el cliente lo hace con un token o una firma, no con un certificado.

### Identidad SPIFFE y Rotación
Cada pod recibe una identidad **SPIFFE** (`spiffe://remarket.internal/ns/prod/sa/pedidos`). La CA de Istio (*istiod*) emite certificados X.509 de **24 horas**, que Envoy rota en memoria sin reiniciar contenedores.

En capa 4, Envoy autentica al servicio emisor por mTLS; en capa 7, el microservicio valida el JWT para autorizar al usuario final.
