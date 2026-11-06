# Examen 2 — Arquitectura Cloud Segura (ReMarket)

**Criptografía y Seguridad 2027-1 · Facultad de Ciencias, UNAM**  
Profesora: María Ximena | Noviembre 2026 | Equipo de 3 integrantes

| Integrante | Rol Principal | Usuario GitHub |
| :--- | :--- | :--- |
| **Oscar David Hernández Rodríguez** | Criptografía en tránsito (Bloque B) | **OscarHeRo** |
| **Ian Alejandro Arroyo Ramírez** | Arquitectura y datos (Bloque A) | **IanFoi** |
| **Violeta Ardeni Castillo Camacho** | Datos en reposo, riesgos y pipeline (Bloque C) | **chateau25** |

## Resumen Ejecutivo

ReMarket es un e-commerce en microservicios sobre AWS diseñado bajo **Zero Trust**. La arquitectura define 6 zonas de confianza, mTLS interno con identidades SPIFFE emitidas por Istio, cifrado en reposo AES-256 con *envelope encryption* en AWS KMS y contraseñas derivadas con Argon2id. Los cobros se delegan a Stripe bajo PCI-DSS SAQ-A sin almacenar datos de tarjeta, los comprobantes se firman con ECDSA P-256 y los webhooks se validan con HMAC-SHA256, ventana de tiempo y registro de eventos ya procesados. El pipeline DevSecOps integra escaneos SAST/SCA bloqueantes y firmas Cosign. La infraestructura es Multi-AZ (RTO ≤ 5 min y RPO = 0 en pagos ante la caída de una zona), y el documento cierra con una evaluación crítica del uso de IA en ciberseguridad.
