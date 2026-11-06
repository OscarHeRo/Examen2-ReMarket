# 6. Protección de Datos Almacenados (Datos en Reposo)

**Por qué no basta HTTPS:** TLS protege el *canal* mientras los datos viajan; al llegar a su destino se descifran y se guardan. Si un atacante roba un disco, un *snapshot* o un respaldo, o entra a la base de datos con credenciales robadas, TLS ya no interviene. Por eso los datos se cifran también en reposo, con claves guardadas lejos de los datos.

### Cifrado de Sobre (*Envelope Encryption*)
Cifrar millones de registros llamando al HSM por cada uno sería lento, así que usamos *envelope encryption* con **AES-256-GCM** y **AWS KMS** (HSM validados FIPS 140 nivel 3):

1. **Clave maestra (KEK):** Vive dentro de KMS y **nunca sale del HSM en claro**. Hay una por servicio y tipo de dato.
2. **Claves de datos (DEK):** KMS genera una DEK; el servicio la usa en memoria para cifrar y autenticar el campo o archivo con AES-256-GCM y descarta la copia en claro. Junto al dato sólo se guarda la DEK cifrada por la KEK. Para leer, el servicio pide a KMS descifrar la DEK, lo que exige un rol IAM autorizado y queda en CloudTrail.
3. **Cifrado de discos y almacenamiento:** Volúmenes EBS, RDS, DynamoDB, S3 y snapshots usan cifrado nativo con claves KMS propias (no las administradas por defecto), así que sin permiso de KMS un snapshot copiado es ilegible.
4. **Cifrado de respaldos:** Los respaldos se cifran con una **clave KMS distinta** y se copian a una **cuenta de AWS separada** con S3 Object Lock en modo cumplimiento (WORM), para que ni credenciales robadas de producción ni un *ransomware* puedan borrarlos o leerlos.
5. **Separación de claves, datos y secretos:** Las claves están en KMS, los datos en RDS/S3 y las contraseñas de servicios en Secrets Manager; cada uno con permisos IAM distintos. Robar un solo componente no basta.

**Límite honesto:** el cifrado en reposo no detiene una inyección SQL, porque la aplicación descifra al consultar. Contra eso aplican consultas parametrizadas, el usuario de BD de mínimo privilegio por servicio y el WAF.
