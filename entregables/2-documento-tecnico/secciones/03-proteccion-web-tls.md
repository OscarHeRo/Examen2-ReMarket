# 3. Protección de la Página Web (Usuario ↔ ReMarket)

**Qué problema resuelve HTTPS:** sin él, cualquiera en la misma red (Wi-Fi pública, ISP, proxy) podría leer contraseñas y tokens, modificar la página o los montos en tránsito, o hacerse pasar por la tienda. HTTPS es HTTP dentro de **TLS**, que da tres garantías: autenticación del servidor, confidencialidad e integridad.

La conexión termina en CloudFront (y CloudFront re-cifra hacia el ALB). Usamos **TLS 1.3** como preferente y aceptamos **TLS 1.2 sólo con ECDHE y suites AEAD** (política `TLSv1.2_2021`): bloquear TLS 1.2 por completo dejaría fuera a clientes internacionales con equipos antiguos, y con esas suites TLS 1.2 no tiene debilidades prácticas conocidas. SSLv3, TLS 1.0 y 1.1 quedan bloqueados para evitar ataques de degradación.

### Configuración y Garantías Criptográficas
1. **Autenticación del servidor (certificados X.509):** ACM emite el certificado de `remarket.com` con clave **ECDSA P-256**, firmado por una CA reconocida. El navegador verifica la cadena hasta una CA de confianza, que el nombre coincida y la vigencia; luego el servidor firma el *handshake* con su clave privada, demostrando que la posee. Un atacante *Man-in-the-Middle* no puede presentar un certificado válido para el dominio.
2. **Confidencialidad e integridad (AEAD):** Cada registro TLS se cifra y autentica con `TLS_AES_256_GCM_SHA384` o `TLS_CHACHA20_POLY1305_SHA256` (móviles sin aceleración AES). Un byte alterado en tránsito hace fallar la etiqueta de autenticación y la conexión se corta.
3. **Secreto hacia adelante (PFS):** Intercambio efímero **ECDHE sobre X25519**. Si la clave privada del servidor se filtra después, las sesiones capturadas antes no pueden descifrarse.
4. **HSTS Preload:** `Strict-Transport-Security: max-age=63072000; includeSubDomains; preload` obliga al navegador a usar sólo HTTPS y evita la degradación a texto claro (*SSL stripping*).

Se excluyen suites vulnerables (CBC, RC4, intercambio RSA estático), y TLS 1.3 reduce el *handshake* a un solo viaje de ida y vuelta (1-RTT).
