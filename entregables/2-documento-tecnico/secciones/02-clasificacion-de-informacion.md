# 2. Clasificación de Información

En ReMarket clasificamos los activos en cuatro niveles (**Crítica**, **Confidencial**, **Interna** y **Pública**) para optimizar el gasto computacional y el cumplimiento regulatorio:

| Tipo de Dato | Nivel | 1. Generación | 2. Almacenamiento | 3. Circulación (Tránsito) | 4. Acceso Autorizado |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **1. Credenciales** | Crítica | Navegador | BD Usuarios (Argon2id) | Frontend $\to$ Gateway $\to$ Auth | Solo servicio de Auth |
| **2. Datos Personales** | Confidencial | Cliente (registro) | BD Usuarios (AES-256) | Gateway $\to$ Auth / Pedidos | Cliente y soporte |
| **3. Direcciones** | Confidencial | Cliente (checkout) | BD Transaccional (AES-256) | Pedidos $\to$ Paquetería | Pedidos y DHL/FedEx |
| **4. Info. de Pedidos** | Confidencial | Servicio Pedidos | BD Transaccional Multi-AZ | Pedidos $\to$ Pagos $\to$ SQS | Cliente, Pedidos, Avisos |
| **5. Inventario** | Interna | Almacén / ERP | BD Transaccional y Redis | Catálogo, Pedidos, Inventario | Lectura pública, admin |
| **6. Info. de Pagos** | Crítica | Stripe Elements | Sin PAN; solo token | Cliente $\to$ Stripe $\to$ Pagos | Solo servicio de Pagos |
| **7. Tokens Sesión** | Crítica | Servicio Auth | Cookie segura / Redis | Cliente $\to$ Gateway $\to$ Pods | Gateway y microservicios |
| **8. Bitácoras Audit** | Confidencial | Agentes en pods | S3 Object Lock (WORM) | Microservicios $\to$ SIEM | Oficial de Seguridad |
| **9. Claves Cripto** | Crítica | AWS KMS / HSM | CloudHSM (no exportables) | Memoria volátil del pod | Roles IAM (IRSA) |

### Impacto ante Falla de Seguridad (CID: Confidencialidad, Integridad y Disponibilidad)
- **1. Credenciales:** (C) Robo masivo de cuentas. (I) Suplantación de identidad. (D) Clientes legítimos bloqueados.
- **2-3. Datos Personales y Direcciones:** (C) Fuga de datos y sanciones legales (LFPDPPP/GDPR). (I) Envíos a domicilios falsos o alterados. (D) Imposibilidad de entrega de paquetería.
- **4-5. Pedidos e Inventario:** (C) Exposición de hábitos de compra. (I) Desfase de stock y sobreventa (*overselling*). (D) Cancelación y parálisis en la generación de órdenes.
- **6. Pagos:** (C) Fraude financiero y exposición fiscal. (I) Aprobación fraudulenta de compras no pagadas. (D) Interrupción total del cobro en caja.
- **7. Tokens de Sesión:** (C) Secuestro de sesión (*session hijacking*). (I) Escalada de privilegios administrativos. (D) Cierre forzado y pérdida de sesiones activas.
- **8. Bitácoras de Auditoría:** (C) Exposición de topología interna. (I) Manipulación y borrado de huellas forenses. (D) Pérdida de visibilidad ante incidentes activos.
- **9. Claves Criptográficas:** (C/I/D) Impacto catastrófico total: descifrado masivo de datos en reposo y suplantación integral del sistema.

### Criterios de Protección Diferenciada
Evitamos gasto innecesario de cómputo: datos bancarios delegados a Stripe (PCI SAQ-A sin guardar tarjetas en disco), contraseñas con KDF costosa en memoria y bitácoras inmutables WORM, dejando el catálogo optimizado para lecturas públicas.
