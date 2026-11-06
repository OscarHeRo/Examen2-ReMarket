# 15. Disponibilidad y Continuidad del Negocio

Para resistir caídas de centros de datos y absorber picos de tráfico en ventas masivas (Hot Sale, Buen Fin), ReMarket implementa redundancia y autoescalado:

### Estrategias de Resiliencia
1. **Redundancia Multi-AZ:** EKS distribuido en 3 Zonas de Disponibilidad. Amazon RDS PostgreSQL opera en Multi-AZ con réplica síncrona y failover automático (<60 s).
2. **Autoescalado Elástico:** HPA ajusta réplicas de pods por CPU y colas SQS; Karpenter aprovisiona nodos EC2 en segundos.
3. **Caché en el Borde:** CloudFront absorbe el 80% de lecturas estáticas, protegiendo a los microservicios.

### Objetivos de Recuperación Operativa (RTO y RPO)

| Servicio | RTO | RPO | Justificación Técnica |
| :--- | :---: | :---: | :--- |
| **1. Pagos y Cobros** | **$\le$ 5 min** | **0 s (RPO = 0)** | Tolerancia cero a pérdida de dinero. RPO=0 con réplica síncrona Multi-AZ en RDS; RTO de 5 min absorbe el failover automático de BD. |
| **2. Auth y Usuarios** | **$\le$ 15 min** | **$\le$ 15 min** | Sesiones activas sostenidas con tokens JWT existentes; altas recientes restauradas vía *Point-in-Time Recovery* (PITR) con logs WAL en S3. |
| **3. Catálogo** | **$\le$ 30 min** | **$\le$ 1 hora** | Lecturas tolerantes a desfases; navegación soportada en caché (CloudFront/Redis) mientras se restauran snapshots en S3. |

Esta estrategia prioriza consistencia e inversión en pagos y resiliencia ágil en servicios de lectura diferida.
