# Bitácora de trabajo

Registro corto de cada sesión del equipo. Sirve para dos cosas: retomar el hilo sin
releerlo todo, y poder justificar el proceso si la profesora lo pregunta.

Formato: una entrada por sesión, lo más corta posible.

---

## Plantilla

### AAAA-MM-DD — _título de la sesión_

**Asistentes:**
**Duración:**

**Qué se decidió:**
-

**Qué se avanzó:**
-

**Bloqueos:**
-

**Siguiente paso y quién lo toma:**
-

---

### 2026-11-05 — Sesión 4: Consolidación, Auditoría de IA y Cierre de Entregables

**Asistentes:** Ian Alejandro Arroyo Ramírez, Oscar David Hernández Rodríguez, Violeta
**Duración:** 4 horas

**Qué se decidió:**
- Concluir el Entregable 5 documentando 3 vectores de ataque de IA y 3 evaluaciones críticas (aceptando mTLS en event bus, descartando cifrado homomórfico para Stripe, y rechazando claves simétricas en cliente).
- Correr `./construir.sh` y calibrar la extensión del documento técnico a 5,320 palabras (≈ 10 páginas), respetando el límite estricto de la rúbrica.
- Validar trazabilidad total entre la matriz de riesgos (R1-R6), los controles del pipeline DevSecOps y las secciones de arquitectura.

**Qué se avanzó:**
- Completados al 100% los 5 entregables del examen.
- Secciones 00 a 17 revisadas, estructuradas y compiladas en `documento-tecnico.md`.
- Evidencias de IA generadas en `entregables/5-analisis-ia/evidencia/`.

**Bloqueos:**
- Ninguno pendiente. El script `./construir.sh` corre exitosamente sin advertencias de longitud.

**Siguiente paso y quién lo toma:**
- Preparar la revisión y entrega final del repositorio del equipo en Classroom (Todos).

---

### 2026-11-04 — Sesión 3: DevSecOps, Seguridad en Reposo y Análisis de Riesgos

**Asistentes:** Ian Alejandro Arroyo Ramírez, Oscar David Hernández Rodríguez, Violeta
**Duración:** 3.5 horas

**Qué se decidió:**
- Diseñar el pipeline CI/CD en 8 etapas con autenticación OIDC hacia AWS (sin credenciales estáticas).
- Aplicar envelope encryption con AES-256-GCM y AWS KMS HSM FIPS 140-2 Nivel 3.
- Definir 6 riesgos cuantitativos ($I 	imes P$) cubriendo credenciales, tránsito, almacenamiento, disponibilidad, supply chain y pasarela de pagos.

**Qué se avanzó:**
- Entregable 3 (`matriz-riesgos.md`) y Entregable 4 (`pipeline-devsecops.md`) redactados y validados.
- Secciones 06, 07, 08, 12, 13, 14 y 15 completadas.

**Bloqueos:**
- Inicialmente el conteo de palabras excedía las 10 páginas; se planificó condensar en la sesión de cierre.

**Siguiente paso y quién lo toma:**
- Desarrollar el Entregable 5 de IA y ajustar conteo de palabras (Todos).

---

### 2026-11-03 — Sesión 2: Criptografía en Tránsito y Pasarela de Pagos

**Asistentes:** Ian Alejandro Arroyo Ramírez, Oscar David Hernández Rodríguez, Violeta
**Duración:** 3 horas

**Qué se decidió:**
- Establecer TLS 1.3 con ECDHE (X25519) en el perímetro y mTLS con SPIFFE/SPIRE en la malla interna de microservicios.
- Definir arquitectura SAQ-A para pagos mediante Stripe Elements (ReMarket nunca toca ni almacena PAN/CVV).
- Asegurar el webhook `POST /payment-confirmed` mediante HMAC-SHA256, ventana de 300s y verificación out-of-band a la API de Stripe.

**Qué se avanzó:**
- Secciones 03, 04, 05, 09, 10 y 11 completadas con las cuatro preguntas clave contestadas.

**Bloqueos:**
- Ninguno.

**Siguiente paso y quién lo toma:**
- Desarrollar Bloque C (Datos en reposo, DevSecOps y riesgos) (Violeta / Todos).

---

### 2026-11-02 — Sesión 1: Kickoff, Definición de Arquitectura y Sprint 1

**Asistentes:** Ian Alejandro Arroyo Ramírez, Oscar David Hernández Rodríguez, Violeta
**Duración:** 2.5 horas

**Qué se decidió:**
- Selección de proveedor cloud: AWS (us-east-1).
- Zonas de confianza: Z0 (Internet), Z1 (Edge/WAF), Z2 (DMZ Ingress), Z3 (App Mesh privada), Z4 (Data/Storage), Z5 (Gestión de seguridad/KMS).
- Distribución de bloques de trabajo según `equipo-y-asignacion.md`.

**Qué se avanzó:**
- Entregable 1 (`arquitectura.mmd`) completado con 14 componentes y servicios de seguridad.
- Sección 01 y Sección 02 (clasificación de 9 tipos de datos × 7 preguntas) terminadas.

**Bloqueos:**
- Ninguno.

**Siguiente paso y quién lo toma:**
- Iniciar el Sprint 2 de Criptografía en tránsito y reposo (Oscar y Violeta).

---

<!-- Las entradas nuevas van arriba de esta línea, la más reciente primero. -->

---

### 2026-11-06 — Sesión 5: Revisión de la propuesta y correcciones

**Asistentes:** Oscar David Hernández Rodríguez
**Duración:** 1 sesión

**Qué se decidió:**
- Usar **SNS → SQS** como bus de eventos (se descarta Kafka); `PedidoPagado` lo publica y firma Pagos.
- API Gateway = **Istio Ingress Gateway** detrás del ALB; identidades SPIFFE emitidas por la CA de Istio (sin SPIRE).
- Token de acceso en memoria (`Bearer`) + token de refresco en cookie `HttpOnly`.
- **KMS** para cifrado de sobre y firma de eventos; **CloudHSM** sólo para la llave de firma de comprobantes.
- Rehacer la evidencia de IA con una consulta real y documentada (Claude, de Anthropic) sobre el prompt de evaluación.
- Aceptar 12 páginas + anexo con el diagrama.

**Qué se avanzó:**
- Revisión completa de la rama `propuesta-solucion`; correcciones técnicas en secciones 00–17, diagrama, matriz de riesgos y entregable 5.
- `construir.sh` corregido (encabezado de Chrome, título duplicado, fórmulas, anchos de tabla) y diagrama reexportado en alta resolución.

**Bloqueos:**
- Ninguno: los datos de Violeta (Violeta Ardeni Castillo Camacho, `chateau25`) ya están en la portada.

**Siguiente paso y quién lo toma:**
- Ian y Violeta revisan las correcciones antes de fusionar a `main` (Todos).
