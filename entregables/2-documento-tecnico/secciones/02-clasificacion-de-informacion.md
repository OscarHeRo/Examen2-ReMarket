# 2. Clasificación de Información

Clasificamos los activos en cuatro niveles (**Crítica**, **Confidencial**, **Interna** y **Pública**). El nivel decide el control: lo crítico se cifra, se aísla y se audita; lo público sólo necesita integridad y disponibilidad.

| Tipo de Dato | Nivel | 1. Generación | 2. Almacenamiento | 3. Circulación | 4. Acceso Autorizado |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **1. Credenciales** | Crítica | Navegador (registro y login) | BD Usuarios (sólo hash Argon2id) | Frontend → Gateway → Auth | Sólo servicio Auth |
| **2. Datos Personales** | Confidencial | Cliente (registro) | BD Usuarios (AES-256) | Gateway → Auth / Pedidos | Cliente, Auth y soporte |
| **3. Direcciones** | Confidencial | Cliente (checkout) | BD Transaccional (AES-256) | Pedidos → Paquetería | Pedidos y paquetería |
| **4. Pedidos** | Confidencial | Servicio Pedidos | BD Transaccional (esquema pedidos) | Pedidos → Pagos → bus | Cliente, Pedidos, Notificaciones |
| **5. Inventario** | Interna | Inventario / ERP | BD Transaccional y Redis | Inventario → Catálogo, Pedidos | Inventario (escritura); el público sólo ve "disponible / agotado" |
| **6. Pagos** | Crítica | Stripe Elements | Sólo ID de pago y estado; nunca tarjeta | Cliente → Stripe → Pagos | Sólo servicio Pagos |
| **7. Tokens de Sesión** | Crítica | Servicio Auth | Acceso: memoria del navegador; refresco: cookie HttpOnly + Redis | Cliente → Gateway → Pods | Gateway y microservicios |
| **8. Bitácoras de Auditoría** | Confidencial | Envoy y microservicios | S3 Object Lock (WORM) | Microservicios → SIEM | Equipo de seguridad |
| **9. Claves Criptográficas** | Crítica | AWS KMS / CloudHSM | KEKs dentro del HSM (no exportables) | Sólo DEKs, en memoria del pod | Roles IAM (IRSA) |

### 5–7. Impacto si se Compromete Confidencialidad, Integridad o Disponibilidad

| Tipo | (C) Si se filtra | (I) Si se modifica | (D) Si no está disponible |
| :--- | :--- | :--- | :--- |
| **1. Credenciales** | Robo de cuentas y *credential stuffing* | Suplantación o bloqueo del titular | Nadie puede iniciar sesión |
| **2. Datos personales** | Sanción LFPDPPP/GDPR y pérdida de confianza | Datos de contacto falsos, fraude | Sin perfil ni historial |
| **3. Direcciones** | Riesgo físico para el cliente | Paquete enviado a un tercero | No se puede entregar |
| **4. Pedidos** | Exposición de hábitos de compra | Cambio de productos o montos | No se pueden crear ni consultar órdenes |
| **5. Inventario** | Ventaja a competidores | Sobreventa o productos bloqueados | Ventas detenidas |
| **6. Pagos** | Fraude financiero | Pedido marcado como pagado sin cobro | Caja detenida |
| **7. Tokens de sesión** | Secuestro de sesión | Escalada de privilegios | Usuarios expulsados |
| **8. Bitácoras** | Exposición de topología interna | Borrado de huellas forenses | Ceguera ante incidentes |
| **9. Claves** | Descifrado masivo y firmas falsas | Suplantación integral del sistema | Datos cifrados inaccesibles para la propia empresa |
