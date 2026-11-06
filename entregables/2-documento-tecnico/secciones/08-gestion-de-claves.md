# 8. Gestión de Claves Criptográficas

La arquitectura de ReMarket prohíbe el almacenamiento de claves, contraseñas o certificados dentro del código fuente (*hardcoding*). Incrustar credenciales en el repositorio genera persistencia en el historial de Git, distribuye secretos de producción entre desarrolladores y clonaciones locales, e impide una revocación ágil ante incidentes de seguridad al exigir recompilación y despliegue de emergencia.

Para desacoplar la seguridad del código, todas las claves criptográficas y secretos operativos se administran de forma centralizada en **AWS CloudHSM / KMS** (certificado **FIPS 140-2 Nivel 3**) y **AWS Secrets Manager**, inyectándose dinámicamente en la memoria RAM de los microservicios durante su ejecución.

### Ciclo de Vida de las Claves
1. **Generación:** Creación de claves maestras dentro de módulos HSM mediante generadores físicos de números aleatorios (TRNG).
2. **Almacenamiento:** Las claves maestras (KEK) son **no exportables**; el hardware criptográfico impide extraerlas en texto claro bajo cualquier circunstancia.
3. **Acceso y Autorización:** Restringido por políticas de menor privilegio de AWS IAM vinculadas a roles de servicio de Kubernetes (IRSA). Toda solicitud criptográfica se registra en AWS CloudTrail para auditoría forense.
4. **Rotación Programada:** Rotación automática anual (365 días) en KMS para claves maestras de cifrado de sobre, y cada 90 días en Secrets Manager para credenciales operativas.
5. **Revocación:** Capacidad de desactivación instantánea de claves comprometidas (*Key State: Disabled*), invalidando operaciones de descifrado en tiempo real sin reiniciar microservicios.
6. **Respaldo y Resiliencia:** Réplicas sincronizadas y cifradas entre clústeres HSM distribuidos en múltiples Zonas de Disponibilidad.
7. **Eliminación Segura:** Periodo forzoso de retención pendiente (7 a 30 días) antes de la destrucción física criptográfica irreversible (*Cryptographic Erasure*).
