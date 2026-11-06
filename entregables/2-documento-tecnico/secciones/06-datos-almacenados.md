# 6. Protección de Datos Almacenados (Datos en Reposo)

La protección del canal de comunicación (TLS 1.3) termina al alcanzar los balanceadores y servidores perimetrales. Si un atacante lograra vulnerar el servidor, ejecutar una inyección SQL o sustraer un respaldo de base de datos (*backup leak*), la seguridad en tránsito no previene que los datos sean leídos directamente del medio de almacenamiento. Por esta razón, ReMarket implementa cifrado en reposo multinivel con separación estricta entre los datos persistidos y las claves criptográficas de descifrado.

### Cifrado de Sobre (*Envelope Encryption*)
Para cifrar millones de registros sin saturar la red ni degradar la latencia hacia un hardware centralizado, implementamos *Envelope Encryption* mediante **AES-256-GCM** en coordinación con **AWS KMS / CloudHSM** (certificado **FIPS 140-2 Nivel 3**):

1. **Clave Maestra de Cifrado de Claves (KEK):** Reside permanentemente dentro del hardware criptográfico HSM; **nunca sale del módulo en texto claro**.
2. **Claves de Cifrado de Datos (DEK):** KMS genera claves rápidas e independientes para cada microservicio. El pod utiliza la DEK en memoria RAM para cifrar y autenticar el registro con AES-256-GCM y descarta la clave en claro inmediatamente. En PostgreSQL solo se almacena el texto cifrado junto con la DEK protegida (*wrapped*) por la KEK.
3. **Almacenamiento de Bloque y Respaldos Inmutables:** Los discos EBS y la base de datos PostgreSQL cuentan con cifrado de bloque nativo. Los respaldos se depositan en Amazon S3 protegidos con **S3 Object Lock** en modo cumplimiento (WORM), impidiendo su modificación o borrado malicioso ante ataques de *ransomware* o credenciales comprometidas.

Esta separación física y lógica asegura que, aun si un atacante extrae una copia física de la base de datos o de los respaldos, la información resulte completamente ilegible al no contar con permisos de descifrado autenticados en KMS.
