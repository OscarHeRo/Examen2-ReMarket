# 3. Protección de la Página Web (Usuario ↔ ReMarket)

La comunicación entre los clientes y la plataforma opera exclusivamente sobre **TLS 1.3** (RFC 8446) terminado en CloudFront y en el Application Load Balancer, bloqueando versiones obsoletas (SSLv3 a TLS 1.2) para evitar ataques de degradación (*downgrade attacks*).

### Configuración y Garantías Criptográficas
1. **Autenticación del Servidor:** Certificados digitales **X.509** gestionados por AWS Certificate Manager (ACM) con claves asimétricas **ECDSA P-256**, validando la identidad de la tienda ante los navegadores y evitando la suplantación por atacantes Man-in-the-Middle (MitM).
2. **Confidencialidad e Integridad (AEAD):** Cifrado simétrico de datos en tránsito con suites de cifrado autenticado (AEAD): `TLS_AES_256_GCM_SHA384` como estándar principal y `TLS_CHACHA20_POLY1305_SHA256` para dispositivos móviles sin aceleración por hardware de AES. Cada bloque transportado verifica criptográficamente su integridad para detectar manipulaciones en tránsito.
3. **Privacidad Hacia Adelante (Perfect Forward Secrecy):** Intercambio efímero de claves mediante **ECDHE sobre X25519**. Si la clave privada del servidor llegara a comprometerse en el futuro, las sesiones pasadas capturadas por terceros no podrán ser descifradas.
4. **Protección de Canal con HSTS Preload:** Cabecera `Strict-Transport-Security: max-age=63072000; includeSubDomains; preload`, que fuerza a los navegadores a conectarse únicamente mediante HTTPS y evita ataques de degradación a texto claro (*SSL Stripping*).

Esta configuración elimina suites vulnerables (como CBC, RC4 o intercambio RSA estático) y reduce la sobrecarga de conexión a un solo viaje de ida y vuelta (1-RTT), asegurando navegación rápida y protegida frente a espías en redes públicas.
