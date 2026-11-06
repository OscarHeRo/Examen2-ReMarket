# Equipo y asignación de trabajo

## Integrantes

| Nombre | Nombre completo | Nº de cuenta | Usuario GitHub |
| --- | --- | --- | --- |
| Oscar | Oscar David Hernández Rodríguez | | OscarHeRo |
| Ian | Ian Alejandro Arroyo Ramírez | |IanFoi |
| Violeta | Violeta Ardeni Castillo Camacho | | chateau25 |

> Completar al aceptar la invitación al repositorio.

---

## Propuesta de reparto

**Es una propuesta, no una imposición** — está pensada para que los tres bloques pesen
parecido y para que nadie dependa de que otro termine primero. Ajústenla en la primera
reunión y marquen aquí quién toma cada bloque.

### Bloque A — Arquitectura y datos · _asignado a: Ian Alejandro Arroyo Ramírez (`IanFoi`)_

| Qué | Dónde |
| --- | --- |
| **Entregable 1** — Diagrama de arquitectura | `entregables/1-diagrama-arquitectura/` |
| Sección 01 — Arquitectura general | `…/secciones/01-arquitectura-general.md` |
| Sección 02 — Clasificación de información | `…/secciones/02-clasificacion-de-informacion.md` |
| Sección 15 — Disponibilidad y continuidad | `…/secciones/15-disponibilidad-continuidad.md` |

> Este bloque **va primero**: los otros dos dependen de que exista el diagrama y la
> clasificación de información para poder justificar sus mecanismos.

### Bloque B — Criptografía en tránsito · _asignado a: Oscar David Hernández Rodríguez_

| Qué | Dónde |
| --- | --- |
| Sección 03 — Protección de la página web (TLS) | `…/secciones/03-proteccion-web-tls.md` |
| Sección 04 — Comunicación entre microservicios | `…/secciones/04-comunicacion-microservicios.md` |
| Sección 05 — API REST (`POST /pedido`) | `…/secciones/05-api-rest.md` |
| Sección 09 — Pasarela de pagos (+ webhook) | `…/secciones/09-pasarela-de-pagos.md` |
| Sección 10 — Firmas digitales e integridad | `…/secciones/10-firmas-digitales.md` |
| Sección 11 — Comunicación asíncrona | `…/secciones/11-comunicacion-asincrona.md` |

### Bloque C — Datos en reposo, riesgos y pipeline · _asignado a: Violeta Ardeni Castillo Camacho (`chateau25`)_

| Qué | Dónde |
| --- | --- |
| Sección 06 — Protección de datos almacenados | `…/secciones/06-datos-almacenados.md` |
| Sección 07 — Contraseñas | `…/secciones/07-contrasenas.md` |
| Sección 08 — Gestión de claves criptográficas | `…/secciones/08-gestion-de-claves.md` |
| Sección 13 — Seguridad de contenedores | `…/secciones/13-seguridad-contenedores.md` |
| **Entregable 3** — Matriz de riesgos (+ sección 14) | `entregables/3-matriz-riesgos/` |
| **Entregable 4** — Pipeline DevSecOps (+ sección 12) | `entregables/4-pipeline-devsecops/` |

### Trabajo conjunto — los tres

| Qué | Dónde | Cómo se reparte |
| --- | --- | --- |
| **Entregable 5** — Análisis de IA (+ sección 16) | `entregables/5-analisis-ia/` | **un escenario de atacante y una observación de evaluador por persona** |
| Sección 17 — Reflexión final | `…/secciones/17-reflexion-final.md` | se redacta en la última reunión, entre los tres |
| Sección 00 — Portada y resumen ejecutivo | `…/secciones/00-portada-y-resumen.md` | quien coordine, **al final** |
| Revisión cruzada | Pull Requests | nadie hace merge de lo suyo sin que otro lo revise |

---

## Dependencias a tener en cuenta

```
Bloque A (diagrama + clasificación)
        ↓
Bloques B y C  ─────┐   (en paralelo, no se bloquean entre sí)
        ↓           ↓
   Matriz de riesgos (necesita B y C para saber qué puede fallar)
        ↓
   Análisis de IA (necesita la arquitectura ya cerrada para evaluarla)
        ↓
   Reflexión final + resumen ejecutivo
```

**Consecuencia práctica:** el diagrama no puede quedarse para el final. Si el bloque A se
atrasa, se atrasa todo.

---

## Reglas de coordinación

1. **Nadie edita la sección de otro.** Si ves algo que corregir, coméntalo en su PR.
2. Si una decisión de arquitectura cambia (p. ej. "mejor mTLS solo en estos tramos"), se
   avisa al grupo **antes** de escribirla: afecta a secciones de los tres.
3. Terminología común desde el principio — nombres de servicios, zonas de confianza, escala
   de sensibilidad. Si cada quien llama distinto a la misma cosa, el documento se lee como
   tres documentos pegados, y eso se nota al calificar.
4. Fecha límite interna: **dos días antes de la entrega real**, para revisión y recorte a
   8–10 páginas.
