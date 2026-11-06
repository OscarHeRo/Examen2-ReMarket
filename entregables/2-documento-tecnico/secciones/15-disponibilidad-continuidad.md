# 15. Disponibilidad y Continuidad del Negocio

Para resistir la caída de un centro de datos y absorber picos de ventas (Hot Sale, Buen Fin), ReMarket combina redundancia, balanceo y autoescalado:

1. **Balanceo de carga:** CloudFront reparte el tráfico global y el ALB lo distribuye entre pods sanos de tres zonas; los *health checks* sacan de rotación a los que fallan.
2. **Múltiples zonas y redundancia:** EKS corre en 3 zonas de disponibilidad con al menos dos réplicas por servicio. RDS opera en Multi-AZ con réplica síncrona y *failover* automático (alrededor de 60 s).
3. **Autoescalado:** HPA ajusta réplicas por CPU y por longitud de las colas SQS; Karpenter agrega nodos EC2 cuando faltan.
4. **Respaldo, replicación y recuperación:** *Point-in-Time Recovery* en RDS y DynamoDB con copias en otra cuenta (sección 6), y *runbooks* de restauración probados cada trimestre.

### Objetivos de Recuperación (RTO y RPO)

| Servicio | RTO | RPO | Justificación |
| :--- | :---: | :---: | :--- |
| **1. Pagos** | **≤ 5 min** | **0** | Perder un cobro es perder dinero o cobrar dos veces. La réplica síncrona Multi-AZ no pierde transacciones si cae una zona; 5 min cubren el *failover* de la BD. Ante corrupción lógica (que la réplica también copia) se restaura con PITR y se concilia con Stripe, que es la fuente de verdad del cobro. |
| **2. Auth y Usuarios** | **≤ 15 min** | **≤ 5 min** | Sin login no hay compras, pero las sesiones activas siguen funcionando con sus tokens. PITR de RDS permite volver a un punto de hace pocos minutos. |
| **3. Catálogo** | **≤ 30 min** | **≤ 1 h** | Mientras se recupera, CloudFront sigue sirviendo la última versión en caché; el catálogo cambia pocas veces al día, así que perder una hora de cambios es aceptable. |
