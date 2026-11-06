# IA como Atacante — Análisis de Escenarios de Amenaza

> **Responsable:** Equipo (Oscar, Ian, Violeta) · **Estado:** ✅ Listo

En este entregable se analizan tres escenarios donde un adversario utiliza modelos de Inteligencia Artificial generativa y herramientas automatizadas para descubrir o explotar debilidades en la arquitectura de **ReMarket**.

---

## Escenario 1 — Spear-Phishing Hipercontextualizado Dirigido al Personal de Soporte

| Pregunta | Respuesta Técnica Fundamentada |
| :--- | :--- |
| **1. ¿Qué activo intenta comprometer?** | Credenciales de acceso a la consola de administración y tokens de sesión de operadores de soporte técnico. |
| **2. ¿Qué debilidad aprovecha?** | El factor humano y la susceptibilidad al engaño mediante ingeniería social basada en urgencia operacional. |
| **3. ¿Qué impacto podría producir?** | Acceso ilegítimo al panel de control de usuarios, visualización de datos personales y posible escalada hacia infraestructura cloud. |
| **4. ¿Qué controles de nuestra arquitectura reducen el riesgo?** | **Autenticación multifactorial (MFA) resistente al phishing mediante llaves de hardware FIDO2 / WebAuthn (YubiKey)** en la VPN administrativa y consola; principio de mínimo privilegio en IAM (roles Just-in-Time sin permisos permanentes); y túnel VPN cifrado con mTLS. |
| **5. ¿Qué evidencia permitiría detectarlo?** | Intentos de inicio de sesión desde direcciones IP anómalas o fuera de geolocalización habitual en CloudWatch/GuardDuty; reportes de usuarios internos ante correos sospechosos; y discrepancias en el User-Agent. |

**Qué aporta la IA aquí que no aportaba el ataque tradicional:**  
La IA permite generar mensajes perfectamente personalizados, adaptando el lenguaje al manual de estilo interno de ReMarket y eliminando errores ortográficos o modismos que alertaban a los filtros tradicionales. Además, permite orquestar campañas masivas dirigidas a cientos de empleados en minutos a costo marginal cero.

---

## Escenario 2 — Fuzzing Semántico y Descubrimiento de APIs con Fallas BOLA

| Pregunta | Respuesta Técnica Fundamentada |
| :--- | :--- |
| **1. ¿Qué activo intenta comprometer?** | La información confidencial de pedidos (`POST /pedido`) y perfiles de clientes almacenados en la base de datos relacional. |
| **2. ¿Qué debilidad aprovecha?** | Fallas de autorización a nivel de objeto (*Broken Object Level Authorization* - OWASP API1:2023) o parámetros no documentados en endpoints REST. |
| **3. ¿Qué impacto podría producir?** | Exfiltración masiva de compras, direcciones y nombres de otros clientes al alterar secuencialmente los identificadores en las peticiones. |
| **4. ¿Qué controles de nuestra arquitectura reducen el riesgo?** | Validación estricta de esquemas OpenAPI en el **API Gateway**; autorización contextual en el microservicio de pedidos verificando que el `user_id` del token JWT firmado con ES256 coincida con el propietario del recurso; y rate-limiting en AWS WAF. |
| **5. ¿Qué evidencia permitiría detectarlo?** | Picos anómalos de respuestas HTTP 403 (Forbidden) y 404 en los registros de acceso de Envoy; ráfagas de solicitudes con IDs dispares desde una misma sesión registradas en OpenSearch SIEM. |

**Qué aporta la IA aquí:**  
En lugar de enviar cargas aleatorias fácilmente bloqueadas por firmas estáticas, los modelos de IA infieren la semántica y relaciones de la API leyendo la documentación pública o analizando respuestas JSON, generando secuencias de peticiones sintácticamente válidas pero lógicamente maliciosas.

---

## Escenario 3 — Reconocimiento Automatizado de Secretos y Llaves en Código Fuente

| Pregunta | Respuesta Técnica Fundamentada |
| :--- | :--- |
| **1. ¿Qué activo intenta comprometer?** | Claves maestras de API de pasarelas de pago (Stripe), certificados privados o credenciales de conexión a bases de datos. |
| **2. ¿Qué debilidad aprovecha?** | Fugas accidentales de secretos en commits de Git, fragmentos de código de prueba o dependencias públicas desactualizadas. |
| **3. ¿Qué impacto podría producir?** | Acceso administrativo directo a recursos en AWS o cobros fraudulentos sin necesidad de vulnerar la red perimetral. |
| **4. ¿Qué controles de nuestra arquitectura reducen el riesgo?** | Pre-commit hooks con **Gitleaks**; escaneo continuo con **TruffleHog**; custodia exclusiva en **AWS Secrets Manager / KMS**; y autenticación en CI/CD mediante **roles efímeros OIDC** (cero claves estáticas en el repositorio). |
| **5. ¿Qué evidencia permitiría detectarlo?** | Alertas de GitHub Secret Scanning y eventos inusuales en AWS CloudTrail invocando APIs desde IPs desconocidas con credenciales recién generadas. |

**Qué aporta la IA aquí:**  
Los analizadores convencionales dependen de expresiones regulares fijas (RegEx). Un agente de IA ofensivo utiliza comprensión del lenguaje para detectar secretos ofuscados, variables renombradas o claves incrustadas en cadenas codificadas en Base64/Hexadecimal que eluden los patrones sintácticos clásicos.
