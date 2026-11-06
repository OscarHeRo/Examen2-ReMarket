# Examen 2 — Diseño de una arquitectura cloud segura para un e-commerce (ReMarket)

**Criptografía y Seguridad 2027-1 · Facultad de Ciencias, UNAM**
Profesora: María Ximena · 100 puntos

Repositorio de trabajo del equipo para el Examen 2. Aquí vive **todo**: el enunciado, el
material del curso que sirve de apoyo, los cinco entregables y la gestión del equipo.

> **Nota para quien acaba de aceptar la invitación:** empieza por
> [`docs/requisitos-del-examen.md`](docs/requisitos-del-examen.md) (la lista completa de lo
> que pide el examen) y luego por [`gestion/equipo-y-asignacion.md`](gestion/equipo-y-asignacion.md)
> (quién hace qué). El PDF original está en [`docs/enunciado/`](docs/enunciado/).

---

## Equipo

| Integrante | Rol principal | Usuario GitHub |
| --- | --- | --- |
| Oscar David Hernández Rodríguez | Criptografía en tránsito (Bloque B) | _pendiente_ |
| Ian Alejandro Arroyo Ramírez | Arquitectura y datos (Bloque A) | IanFoi |
| Violeta | Datos en reposo, riesgos y pipeline (Bloque C) | _pendiente_ |

El examen permite equipos de **máximo 3 personas**. La repartición propuesta está en
[`gestion/equipo-y-asignacion.md`](gestion/equipo-y-asignacion.md).

La profesora recomienda **enfoque ágil** y usar a la IA como *Product Owner* y *Scrum
Master* durante la planificación. El backlog vive en [`gestion/backlog.md`](gestion/backlog.md).

---

## Los 5 entregables

| # | Entregable | Carpeta | Estado |
| --- | --- | --- | --- |
| 1 | Diagrama de arquitectura cloud | [`entregables/1-diagrama-arquitectura/`](entregables/1-diagrama-arquitectura/) | ✅ Listo |
| 2 | Documento técnico (máx. 8–10 páginas) | [`entregables/2-documento-tecnico/`](entregables/2-documento-tecnico/) | ✅ Listo (5,320 palabras ≈ 10 págs) |
| 3 | Matriz de riesgos | [`entregables/3-matriz-riesgos/`](entregables/3-matriz-riesgos/) | ✅ Listo |
| 4 | Diseño del pipeline DevSecOps | [`entregables/4-pipeline-devsecops/`](entregables/4-pipeline-devsecops/) | ✅ Listo |
| 5 | Análisis del uso de la IA | [`entregables/5-analisis-ia/`](entregables/5-analisis-ia/) | ✅ Listo |

Leyenda de estado: ⬜ Sin empezar · 🟨 En progreso · 🟦 En revisión · ✅ Listo

> Actualiza esta tabla en el mismo commit en que avances un entregable. Es el tablero del equipo.

---

## Estructura del repositorio

```
.
├── docs/
│   ├── enunciado/              ← PDF original del Examen 2
│   ├── material-del-curso/     ← diapositivas del curso relacionadas
│   └── requisitos-del-examen.md ← checklist completa extraída del enunciado
├── entregables/
│   ├── 1-diagrama-arquitectura/
│   ├── 2-documento-tecnico/    ← una sección por archivo, para trabajar en paralelo
│   ├── 3-matriz-riesgos/
│   ├── 4-pipeline-devsecops/
│   └── 5-analisis-ia/
└── gestion/
    ├── equipo-y-asignacion.md  ← quién hace qué
    ├── backlog.md              ← sprints y tareas (enfoque ágil)
    └── bitacora.md             ← registro de sesiones de trabajo
```

---

## El criterio que de verdad se evalúa

Del enunciado, textual:

> No se evaluará únicamente si el alumnado menciona tecnologías. Se evaluará
> principalmente si comprende:
> - qué se protege
> - contra qué amenaza se protege
> - qué propiedad criptográfica o control de seguridad se necesita
> - por qué la solución propuesta es adecuada.

**Para cada decisión que escribamos, esas cuatro preguntas deben quedar respondidas.**
Las plantillas de cada sección ya traen esos cuatro huecos. No basta con "se usa HTTPS".

---

## Cómo trabajar aquí

Convenciones de ramas, commits y revisión: [`CONTRIBUTING.md`](CONTRIBUTING.md).

En corto:

```
git switch -c seccion/05-api-rest
# ...escribir...
git commit -m "doc: API REST — protección de POST /pedido"
git push -u origin seccion/05-api-rest
```

Luego abre un Pull Request y pide revisión a alguien más del equipo.
