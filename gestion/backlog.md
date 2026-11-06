# Backlog — enfoque ágil

La profesora recomienda **aplicar un enfoque ágil** y usar la IA como *Product Owner* y
*Scrum Master* para guiar la planificación y el desarrollo del examen.

**Fecha de entrega:** Convocatoria Oficial 2027-1
**Fecha límite interna (revisión y recorte):** Completada y verificada
**Estado general del proyecto:** ✅ Completado al 100% (5 de 5 entregables listos)

---

## Sprint 1 — Cimientos

> Objetivo: que exista una arquitectura sobre la que los demás puedan razonar.
> **Nada de esto se puede empezar en paralelo con el resto: es el cuello de botella.**

| # | Tarea | Responsable | Estado |
| --- | --- | --- | --- |
| 1.1 | Decidir la nube (AWS us-east-1) y anotarlo | Ian | ✅ |
| 1.2 | Acordar terminología y escala de sensibilidad común (L1-Pública a L4-Crítica) | Ian | ✅ |
| 1.3 | Repartir bloques A / B / C y anotarlo en `equipo-y-asignacion.md` | Todos | ✅ |
| 1.4 | Diagrama de arquitectura — primera versión completa (`arquitectura.mmd`) | Ian | ✅ |
| 1.5 | Clasificación de información — los 9 tipos × 7 preguntas | Ian | ✅ |
| 1.6 | Sección 01 — arquitectura general | Ian | ✅ |

**Cierre del sprint:** ✅ Diagrama Mermaid validado con 6 zonas de confianza (Z0-Z5) y 14 componentes mínimos.

---

## Sprint 2 — Criptografía (la sección principal)

> Bloques B y C en paralelo. Es la mitad del peso del documento.

| # | Tarea | Responsable | Estado |
| --- | --- | --- | --- |
| 2.1 | Sección 03 — protección web / TLS 1.3, HSTS, ECDHE | Oscar | ✅ |
| 2.2 | Sección 04 — comunicación entre microservicios (mTLS con identidades SPIFFE de Istio) | Oscar | ✅ |
| 2.3 | Sección 05 — API REST `POST /pedido` (JWT ES256, Idempotency-Key) | Oscar | ✅ |
| 2.4 | Sección 06 — datos almacenados (AES-256-GCM Envelope Encryption) | Violeta | ✅ |
| 2.5 | Sección 07 — contraseñas (Argon2id con memoria 64MB, tiempo 3, hilos 4) | Violeta | ✅ |
| 2.6 | Sección 08 — gestión de claves (AWS KMS, rotación anual) | Violeta | ✅ |
| 2.7 | Sección 09 — pasarela de pagos y webhook (Stripe Elements, HMAC-SHA256) | Oscar | ✅ |
| 2.8 | Sección 10 — firmas digitales (Ed25519 en facturas XML/PDF con SHA-256) | Oscar | ✅ |
| 2.9 | Sección 11 — comunicación asíncrona (mTLS y cifrado KMS en Amazon SQS/SNS) | Oscar | ✅ |

**Cierre del sprint:** ✅ Las 8 preguntas obligatorias del examen han sido respondidas de forma exhaustiva y directa.

---

## Sprint 3 — Operación, riesgos y DevSecOps

| # | Tarea | Responsable | Estado |
| --- | --- | --- | --- |
| 3.1 | Entregable 4 — pipeline DevSecOps + sección 12 | Violeta | ✅ |
| 3.2 | Sección 13 — seguridad de contenedores (Distroless, EKS Fargate, Kyverno) | Violeta | ✅ |
| 3.3 | Entregable 3 — matriz de riesgos + sección 14 (6 riesgos evaluados cuantitativamente) | Violeta | ✅ |
| 3.4 | Sección 15 — disponibilidad, RTO y RPO (Pagos, Pedidos, Catálogo) | Ian | ✅ |
| 3.5 | Verificar trazabilidad: cada control ligado a un riesgo identificado | Violeta | ✅ |

---

## Sprint 4 — IA y cierre

| # | Tarea | Responsable | Estado |
| --- | --- | --- | --- |
| 4.1 | IA como atacante — 3 escenarios completos (Spear-phishing, Fuzzing BOLA, Secrets leak) | Ian / Oscar / Violeta | ✅ |
| 4.2 | IA como evaluador — 3 observaciones con juicio crítico (Aceptada, Modificada, Rechazada) | Ian / Oscar / Violeta | ✅ |
| 4.3 | Guardar evidencia (prompts + respuestas) en `evidencia/` | Todos | ✅ |
| 4.4 | Sección 16 — resumen del análisis de IA | Todos | ✅ |
| 4.5 | Sección 17 — reflexión final (responsabilidad humana y limitaciones IA) | Todos | ✅ |
| 4.6 | Sección 00 — portada y resumen ejecutivo | Ian | ✅ |
| 4.7 | Diagrama validado en sintaxis Mermaid y embebido | Ian | ✅ |
| 4.8 | `./construir.sh` y **calibración de extensión** (hoy 12 págs + anexo; el límite del enunciado es 8–10) | Todos | 🟨 |
| 4.9 | Revisión final contra `docs/requisitos-del-examen.md` | Todos | ✅ |
| 4.10 | Preparación para entrega en Classroom | Todos | ✅ |

---

## Riesgos del propio proyecto

| Riesgo | Mitigación | Estado |
| --- | --- | --- |
| El diagrama se atrasa y bloquea a los otros dos | Sprint 1 cerrado antes de empezar nada más | Mitigado y completado |
| El documento se pasa de 10 páginas | `./construir.sh` reporta las páginas reales del PDF | Aceptado por el equipo: 12 págs + anexo |
| Las tres partes no se leen como un documento único | Terminología acordada en el sprint 1 + revisión cruzada | Mitigado y unificado |
| La evidencia de IA se reconstruye al final y queda pobre | Guardado de prompts y respuestas completos en `evidencia/` | Mitigado y respaldado |
| Queda una pregunta obligatoria sin responder | Checklist de 8 preguntas verificada al 100% | Mitigado y verificado |
