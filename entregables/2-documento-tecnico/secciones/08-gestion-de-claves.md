# 8. Gestión de Claves Criptográficas

**Por qué las claves no van en el código fuente:** el código se copia a cada laptop, al sistema de CI y al historial de Git, donde un secreto queda para siempre aunque luego se borre. Cualquiera con acceso de lectura al repositorio tendría la clave, y cambiarla exigiría recompilar y redesplegar en plena emergencia.

Por eso las claves viven en **AWS KMS** (KEKs y firma de eventos), **AWS CloudHSM** (llave privada de firma de comprobantes) y **AWS Secrets Manager** (contraseñas de servicios, token de Redis, *webhook secret* de Stripe). Los microservicios las obtienen en ejecución con su rol IAM; en el caso de KMS y CloudHSM, la clave nunca llega al pod: el pod pide la operación.

### Ciclo de Vida de las Claves
1. **Generación:** Dentro del HSM con su generador de números aleatorios certificado.
2. **Almacenamiento:** Las KEKs y llaves de firma son **no exportables**; sólo salen DEKs cifradas.
3. **Acceso:** Políticas IAM de mínimo privilegio por servicio (IRSA). Cada uso queda en **CloudTrail**.
4. **Rotación:** KMS rota la KEK cada año (las versiones viejas siguen descifrando datos antiguos); Secrets Manager rota secretos de servicios cada 90 días; Istio rota los certificados mTLS cada 24 h.
5. **Revocación:** Una clave comprometida se deshabilita (*Key State: Disabled*) y deja de servir de inmediato; un secreto filtrado se rota y la versión anterior se invalida.
6. **Respaldo:** KMS replica sus claves entre zonas internamente; el clúster CloudHSM tiene HSM en varias zonas con respaldos cifrados.
7. **Eliminación:** KMS impone una espera de 7 a 30 días antes de borrar. Al borrarse la KEK, todo lo cifrado con ella queda irrecuperable (*borrado criptográfico*), útil para retirar datos de forma verificable.
