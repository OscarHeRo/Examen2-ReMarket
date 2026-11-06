# 7. Gestión de Contraseñas

En ReMarket, la autenticación de usuarios se basa en verificación unidireccional estricta: **el sistema nunca almacena contraseñas en texto claro ni mediante algoritmos de cifrado reversible** (como AES o RSA). Dado que el microservicio de autenticación únicamente necesita validar si la credencial ingresada coincide con la registrada, emplear esquemas descifrables introduciría una falla crítica: la filtración de la clave expondría las credenciales originales de todos los clientes, habilitando ataques de *credential stuffing* en otros servicios.

Asimismo, se descarta el uso de funciones de hash rápido de propósito general (como SHA-256 o MD5), ya que su bajo costo computacional permite calcular miles de millones de intentos por segundo mediante aceleración por GPU y hardware ASIC.

### Derivación de Claves con Argon2id
La protección de credenciales se implementa mediante la función de derivación de claves (*Key Derivation Function*, KDF) **Argon2id** (RFC 9106), ganadora del *Password Hashing Competition*, diseñada específicamente para ofrecer resistencia equilibrada contra ataques de canal lateral y ataques basados en memoria masiva:

1. **Sal Criptográfica (*Salt*):** Cada credencial incorpora 16 bytes pseudoaleatorios generados con un CSPRNG (`/dev/urandom`) durante el registro. Esto garantiza que dos contraseñas idénticas produzcan resúmenes completamente distintos, anulando ataques con tablas precalculadas (*rainbow tables*).
2. **Parámetros de Costo Computacional y Memoria:**
   - **Memoria ($m$):** $64\text{ MB}$ requeridos por cada intento de verificación.
   - **Tiempo ($t$):** $3$ iteraciones de cálculo.
   - **Paralelismo ($p$):** $4$ hilos concurrentes.

Al forzar el consumo de 64 MB de memoria RAM dedicada en cada operación, se satura el ancho de banda y la memoria física de los clústeres de tarjetas de video (GPU), imposibilitando el descifrado masivo por fuerza bruta o ataques de diccionario fuera de línea ante una eventual sustracción de la base de datos.
