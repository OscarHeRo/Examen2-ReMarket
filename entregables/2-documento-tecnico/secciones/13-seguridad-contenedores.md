# 13. Seguridad de Contenedores y Microservicios

El despliegue en Kubernetes exige controles de menor privilegio a nivel de sistema de archivos, clúster y red interna para prevenir escaladas al host y movimientos laterales:

### Endurecimiento de Contenedores (*Hardening*)
1. **Imágenes Base Mínimas (Distroless):** Se eliminan administradores de paquetes (`apt`, `apk`), herramientas de red (`curl`, `nc`, `wget`) e intérpretes de comandos (`sh`, `bash`). Esto reduce la superficie de ataque y bloquea las herramientas utilizadas habitualmente tras un compromiso inicial.
2. **Ejecución sin Privilegios (*Rootless*):** Configurada mediante el `securityContext` del pod: `runAsNonRoot: true`, `allowPrivilegeEscalation: false`, sistema de archivos en solo lectura (`readOnlyRootFilesystem: true` con almacenamiento efímero en `emptyDir` RAM) y remoción total de capacidades del kernel (`capabilities: drop: ["ALL"]`).
3. **Políticas de Red por Defecto Restrictivas:** *NetworkPolicies* de Kubernetes en modo *default-deny* que descartan todo tráfico intra-clúster que no haya sido declarado explícitamente entre pares de pods.

### Contención de Brechas y Prevención de Movimiento Lateral
Para verificar la efectividad de la contención en capas, consideramos el microservicio de **Catálogo**, que por atender millones de consultas públicas presenta la mayor exposición perimetral. Ante un escenario hipotético de ejecución remota de código (RCE) en dicho pod, **tres barreras independientes impiden el acceso a las bases de datos de usuarios o pagos**:

1. **Aislamiento de Red L3/L4:** Las *NetworkPolicies* y *Security Groups* prohíben que los pods de catálogo emitan paquetes hacia las subredes de datos; los intentos de conexión hacia el puerto 5432 de PostgreSQL se descartan en la interfaz virtual.
2. **Autenticación Mutua y Autorización Istio (L4/L7):** Todo intento de invocar APIs internas (como el servicio de Usuarios) requiere mTLS. El sidecar Envoy receptor comprueba la identidad SPIFFE del emisor (`spiffe://remarket.internal/ns/prod/sa/catalogo`) y la rechaza (HTTP 403 Forbidden) mediante su *AuthorizationPolicy*.
3. **Segregación de Permisos IAM en la Nube:** La cuenta de servicio del catálogo (IRSA) carece de permisos IAM para solicitar secretos en Secrets Manager o utilizar claves KMS asociadas a usuarios o pagos.

Este diseño asegura que un compromiso en la capa perimetral quede confinado estrictamente en su entorno de ejecución, protegiendo los activos críticos del sistema.
