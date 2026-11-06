# 7. Gestión de Contraseñas

El servicio de autenticación sólo necesita comprobar que la contraseña escrita coincide con la registrada, nunca recuperarla. Por eso **no se guarda cifrada de forma reversible**: si alguien obtiene la clave de descifrado (o el código que la usa), recupera las contraseñas de todos los clientes y puede reutilizarlas en otros sitios (*credential stuffing*).

| Concepto | Qué es | ¿Sirve para contraseñas? |
| :--- | :--- | :--- |
| **Cifrado** | Transformación reversible con una clave (AES, RSA) | No: quien tenga la clave recupera todo |
| **Hash** | Función de un solo sentido y rápida (SHA-256) | Sola no: una GPU prueba miles de millones por segundo |
| **Salt** | Valor aleatorio único por usuario que se mezcla con la contraseña | Necesario: contraseñas iguales dan resultados distintos e inutiliza tablas precalculadas |
| **KDF de contraseña** | Hash deliberadamente lento y costoso en memoria (Argon2id, scrypt, bcrypt) | Sí: encarece cada intento de fuerza bruta |

### Derivación con Argon2id
Usamos **Argon2id** (RFC 9106), ganador de la *Password Hashing Competition*:

1. **Salt:** 16 bytes de un CSPRNG por credencial, guardados junto al resultado.
2. **Parámetros:** memoria $m = 64$ MiB, $t = 3$ iteraciones y $p = 4$ hilos (una de las configuraciones que recomienda el RFC 9106). Se guardan con el hash para poder subirlos en el futuro y re-derivar al siguiente inicio de sesión.

Exigir 64 MiB por intento hace que un atacante con la base robada sólo pueda probar unas pocas contraseñas por segundo en cada GPU, en lugar de miles de millones con SHA-256. No lo imposibilita, pero lo vuelve impráctico para contraseñas no triviales. Como el costo también lo paga nuestro servidor, `/login` tiene rate limiting por IP y por cuenta en el WAF, para que nadie lo use como vector de denegación de servicio.
