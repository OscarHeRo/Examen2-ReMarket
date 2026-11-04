# Backlog — enfoque ágil

La profesora recomienda **aplicar un enfoque ágil** y usar la IA como *Product Owner* y
*Scrum Master* para guiar la planificación y el desarrollo del examen.

**Fecha de entrega:** _______________
**Fecha límite interna (revisión y recorte):** _______________

---

## Sprint 1 — Cimientos

> Objetivo: que exista una arquitectura sobre la que los demás puedan razonar.
> **Nada de esto se puede empezar en paralelo con el resto: es el cuello de botella.**

| # | Tarea | Responsable | Estado |
| --- | --- | --- | --- |
| 1.1 | Decidir la nube (AWS / Azure / GCP / genérica) y anotarlo | | ⬜ |
| 1.2 | Acordar terminología y escala de sensibilidad común | | ⬜ |
| 1.3 | Repartir bloques A / B / C y anotarlo en `equipo-y-asignacion.md` | | ⬜ |
| 1.4 | Diagrama de arquitectura — primera versión completa | | ⬜ |
| 1.5 | Clasificación de información — los 9 tipos × 7 preguntas | | ⬜ |
| 1.6 | Sección 01 — arquitectura general | | ⬜ |

**Cierre del sprint:** los tres revisan el diagrama juntos. Si alguien no puede explicar una
flecha, la flecha está mal.

---

## Sprint 2 — Criptografía (la sección principal)

> Bloques B y C en paralelo. Es la mitad del peso del documento.

| # | Tarea | Responsable | Estado |
| --- | --- | --- | --- |
| 2.1 | Sección 03 — protección web / TLS | | ⬜ |
| 2.2 | Sección 04 — comunicación entre microservicios | | ⬜ |
| 2.3 | Sección 05 — API REST `POST /pedido` | | ⬜ |
| 2.4 | Sección 06 — datos almacenados | | ⬜ |
| 2.5 | Sección 07 — contraseñas | | ⬜ |
| 2.6 | Sección 08 — gestión de claves | | ⬜ |
| 2.7 | Sección 09 — pasarela de pagos y webhook | | ⬜ |
| 2.8 | Sección 10 — firmas digitales | | ⬜ |
| 2.9 | Sección 11 — comunicación asíncrona | | ⬜ |

**Cierre del sprint:** repasar las **preguntas obligatorias** del enunciado (tabla en
`entregables/2-documento-tecnico/README.md`). Si alguna no está respondida de forma directa,
no se cierra el sprint.

---

## Sprint 3 — Operación, riesgos y DevSecOps

| # | Tarea | Responsable | Estado |
| --- | --- | --- | --- |
| 3.1 | Entregable 4 — pipeline DevSecOps + sección 12 | | ⬜ |
| 3.2 | Sección 13 — seguridad de contenedores | | ⬜ |
| 3.3 | Entregable 3 — matriz de riesgos + sección 14 | | ⬜ |
| 3.4 | Sección 15 — disponibilidad, RTO y RPO | | ⬜ |
| 3.5 | Verificar trazabilidad: cada control ligado a un riesgo | | ⬜ |

---

## Sprint 4 — IA y cierre

| # | Tarea | Responsable | Estado |
| --- | --- | --- | --- |
| 4.1 | IA como atacante — 1 escenario por persona | todos | ⬜ |
| 4.2 | IA como evaluador — 1 observación por persona | todos | ⬜ |
| 4.3 | Guardar evidencia (prompts + respuestas) en `evidencia/` | todos | ⬜ |
| 4.4 | Sección 16 — resumen del análisis de IA | | ⬜ |
| 4.5 | Sección 17 — reflexión final (entre los tres) | todos | ⬜ |
| 4.6 | Sección 00 — portada y resumen ejecutivo | | ⬜ |
| 4.7 | Exportar el diagrama a `exportados/` | | ⬜ |
| 4.8 | `./construir.sh` y **recortar a 8–10 páginas** | | ⬜ |
| 4.9 | Revisión final contra `docs/requisitos-del-examen.md` | todos | ⬜ |
| 4.10 | Entregar en Classroom | | ⬜ |

---

## Riesgos del propio proyecto

| Riesgo | Mitigación |
| --- | --- |
| El diagrama se atrasa y bloquea a los otros dos | Sprint 1 cerrado antes de empezar nada más |
| El documento se pasa de 10 páginas | Presupuesto de páginas por sección desde el inicio |
| Las tres partes no se leen como un documento único | Terminología acordada en el sprint 1 + revisión cruzada en PRs |
| La evidencia de IA se reconstruye al final y queda pobre | Guardar prompts **mientras** se trabaja, no después |
| Queda una pregunta obligatoria sin responder | Checklist de 8 preguntas al cerrar el sprint 2 |
