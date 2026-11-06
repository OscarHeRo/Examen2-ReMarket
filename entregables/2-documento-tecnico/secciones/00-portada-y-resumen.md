# Examen 2 — Arquitectura Cloud Segura (ReMarket)

**Criptografía y Seguridad 2027-1 · Facultad de Ciencias, UNAM**  
Profesora: María Ximena | Noviembre 2026 | Equipo de 3 integrantes

| Integrante | Rol Principal | Usuario GitHub |
| :--- | :--- | :--- |
| **Oscar David Hernández Rodríguez** | Seguridad en Tránsito y APIs | _oscar-dhr_ |
| **Ian Alejandro Arroyo Ramírez** | Arquitectura Cloud y Criptografía | **IanFoi** |
| **Violeta** | DevSecOps y Gestión de Riesgos | _violeta-sec_ |

---

## Resumen Ejecutivo

ReMarket es un e-commerce en microservicios sobre AWS diseñado bajo **Zero Trust**. La arquitectura define 6 zonas de confianza, mTLS interno con identidades SPIRE, cifrado en reposo AES-256 con Envelope Encryption (KMS/CloudHSM FIPS 140-2 L3) y contraseñas hasheadas con Argon2id. Los cobros se delegan a Stripe bajo PCI-DSS SAQ-A sin almacenar datos bancarios, las facturas se firman con ECDSA P-256 y los webhooks se validan con HMAC-SHA256 anti-replay. El pipeline DevSecOps integra escaneos SAST/SCA bloqueantes y firmas Cosign. La infraestructura asegura alta disponibilidad Multi-AZ (RTO $\le$ 5 min y RPO = 0 en pagos), complementada con una evaluación crítica del uso de IA en ciberseguridad.
