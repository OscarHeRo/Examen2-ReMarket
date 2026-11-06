# Entregable 3 — Matriz de riesgos

> **Responsable:** _por asignar_ · **Estado:** ✅ Listo

## Qué pide el examen

**Al menos tres riesgos** relevantes de la arquitectura propuesta, con **mínimo uno de cada
categoría**:

- [ ] credenciales
- [ ] comunicaciones
- [ ] almacenamiento
- [ ] disponibilidad
- [ ] cadena de suministro / pipeline

> ⚠️ Son cinco categorías obligatorias y el mínimo son "tres riesgos". Lo seguro es
> **al menos un riesgo por categoría = 5 riesgos**, así ninguna queda sin cubrir.

Opcionalmente se pueden añadir riesgos de: APIs, microservicios, terceros, pagos,
configuraciones cloud.

## Escala y cálculo (tal cual lo define el enunciado)

| Valor | Nivel |
| --- | --- |
| 3 | Alto |
| 2 | Medio |
| 1 | Bajo |

**Nivel de riesgo = Impacto × Probabilidad**

| Resultado | Clasificación |
| --- | --- |
| 6–9 | **Alto** |
| 3–4 | **Medio** |
| 1–2 | **Bajo** |

> Nota: la escala del enunciado deja fuera el 5 (no sale de multiplicar 1, 2 y 3 entre sí,
> así que no hay problema). Los productos posibles son 1, 2, 3, 4, 6 y 9.

## Tratamiento

Para los riesgos más importantes hay que definir:

- control **preventivo**
- control **detectivo**
- control **correctivo**
- y clasificar el tratamiento: **mitigación · evitación · transferencia · aceptación**

> **Cada control debe estar relacionado directamente con un riesgo identificado.** Es un
> requisito explícito. Un control que no responde a ninguna fila de la matriz sobra.

## Archivo de trabajo

[`matriz-riesgos.md`](matriz-riesgos.md)
