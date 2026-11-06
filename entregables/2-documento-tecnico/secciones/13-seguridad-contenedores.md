# 13. Seguridad de Contenedores y Microservicios

El objetivo es que vulnerar un microservicio no permita escalar al host ni moverse a otros servicios.

### Endurecimiento de Contenedores (*Hardening*)
1. **Imágenes Base Mínimas (Distroless):** Sin gestor de paquetes, `curl`, `wget` ni shell: el atacante no encuentra herramientas tras el compromiso inicial.
2. **Ejecución sin Privilegios (*Rootless*):** Configurada mediante el `securityContext` del pod: `runAsNonRoot: true`, `allowPrivilegeEscalation: false`, sistema de archivos en solo lectura (`readOnlyRootFilesystem: true` con almacenamiento efímero en `emptyDir` RAM) y remoción total de capacidades del kernel (`capabilities: drop: ["ALL"]`).
3. **Actualización de Imágenes:** Las imágenes se reconstruyen cada semana sobre la imagen base más reciente y ECR vuelve a escanear las ya publicadas; una CVE crítica nueva dispara la reconstrucción y el despliegue sin esperar al siguiente cambio de código.
4. **Cuentas de Servicio y Secretos:** Cada microservicio tiene su propia *ServiceAccount* ligada a un rol IAM (IRSA) con sólo los permisos que usa; los secretos se montan en memoria (`tmpfs`) desde Secrets Manager, nunca como variables en la imagen.
5. **Políticas de Red por Defecto Restrictivas:** *NetworkPolicies* de Kubernetes en modo *default-deny* que descartan todo tráfico intra-clúster que no haya sido declarado explícitamente entre pares de pods.

### Contención de Brechas y Prevención de Movimiento Lateral
Para verificar la efectividad de la contención en capas, consideramos el microservicio de **Catálogo**, que por atender millones de consultas públicas presenta la mayor exposición perimetral. Ante un escenario hipotético de ejecución remota de código (RCE) en dicho pod, **tres barreras independientes impiden el acceso a las bases de datos de usuarios o pagos**:

1. **Aislamiento de Red L3/L4:** Las *NetworkPolicies* y *Security Groups* prohíben que los pods de catálogo emitan paquetes hacia las subredes de datos; los intentos de conexión hacia el puerto 5432 de PostgreSQL se descartan en la interfaz virtual.
2. **Autenticación Mutua y Autorización Istio (L4/L7):** Todo intento de invocar APIs internas (como el servicio de Usuarios) requiere mTLS. El sidecar Envoy receptor comprueba la identidad SPIFFE del emisor (`spiffe://remarket.internal/ns/prod/sa/catalogo`) y la rechaza (HTTP 403) mediante su *AuthorizationPolicy*.
3. **Segregación de Permisos IAM y de BD:** El rol del catálogo (IRSA) no puede leer secretos de Secrets Manager ni usar las claves KMS de usuarios o pagos, y no tiene usuario en ninguna base PostgreSQL. Aunque llegara a la base, los campos sensibles están cifrados con claves que no puede usar.
