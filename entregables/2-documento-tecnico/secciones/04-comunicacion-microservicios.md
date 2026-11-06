# 4. Comunicación entre Microservicios

Bajo **Zero Trust**, la red interna de Kubernetes no se considera segura. Gestionamos el tráfico este-oeste con **Istio Service Mesh** y proxies **Envoy**, aplicando autenticación mutua (mTLS) según el tramo:

| Tramo de Comunicación | Mecanismo | ¿Requiere mTLS? | Justificación Técnica |
| :--- | :--- | :---: | :--- |
| **Gateway $\to$ Microservicios** | mTLS estricto + JWT | **SÍ** | El Gateway valida al pod destino y el servicio comprueba que la llamada venga del Gateway perimetral. |
| **Microservicio $\to$ Microservicio** | mTLS estricto + JWT | **SÍ** | Evita suplantaciones internas y espionaje este-oeste si llegan a hackear un pod. |
| **Microservicio $\to$ Redis** | TLS 1.3 + Token | **NO (Unilateral)** | Redis no inicia peticiones. El pod valida a Redis por TLS y se conecta con token en canal seguro. |
| **Microservicio $\to$ RDS PostgreSQL** | TLS 1.3 + AWS IAM | **NO (Unilateral)** | La BD es pasiva. El servicio valida a RDS por TLS y usa credenciales IAM temporales (IRSA). |

### Identidad SPIFFE/SPIRE y Rotación
Cada pod recibe una identidad **SPIFFE** (`spiffe://remarket.internal/ns/prod/sa/pedidos`). El plano de control *istiod* emite certificados X.509 de **24 horas**, rotados en memoria por Envoy sin reiniciar contenedores.

En Capa 4, Envoy asegura el enlace mTLS autenticando al microservicio emisor; en Capa 7, el microservicio valida el token JWT para autorizar los permisos del usuario final.
