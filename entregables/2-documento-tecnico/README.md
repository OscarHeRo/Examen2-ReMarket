# Entregable 2 — Documento técnico

> **Límite duro: 8–10 páginas.** No es una sugerencia, es el enunciado.

## Cómo está organizado

El documento está partido en **una sección por archivo** dentro de
[`secciones/`](secciones/). Es a propósito: así Oscar, Ian y Violeta pueden escribir al
mismo tiempo sin pisarse ni provocar conflictos de merge.

Al final se concatenan en orden numérico con [`construir.sh`](construir.sh).

## Presupuesto de páginas

Son 17 secciones para 8–10 páginas. Reparto propuesto (ajustable, pero la suma no puede
crecer):

| Secciones | Bloque | Páginas |
| --- | --- | --- |
| 00 | Portada y resumen ejecutivo | 0.5 |
| 01–02 | Arquitectura y clasificación de información | 2.0 |
| **03–11** | **Criptografía aplicada** — *sección principal del proyecto* | **4.0** |
| 12–13 | Pipeline DevSecOps y contenedores | 1.0 |
| 14–15 | Riesgos y disponibilidad | 1.0 |
| 16–17 | Uso de IA y reflexión final | 1.5 |
| | **Total** | **10.0** |

El enunciado dice literalmente que criptografía "es la sección principal del proyecto": por
eso se lleva casi la mitad. Si algo hay que recortar, no es de ahí.

## Estado por sección

| # | Sección | Responsable | Estado |
| --- | --- | --- | --- |
| 00 | Portada y resumen ejecutivo | | ✅ |
| 01 | Arquitectura general | | ✅ |
| 02 | Clasificación de información | | ✅ |
| 03 | Protección de la página web (TLS) | | ✅ |
| 04 | Comunicación entre microservicios | | ✅ |
| 05 | API REST — `POST /pedido` | | ✅ |
| 06 | Protección de datos almacenados | | ✅ |
| 07 | Contraseñas | | ✅ |
| 08 | Gestión de claves criptográficas | | ✅ |
| 09 | Pasarela de pagos | | ✅ |
| 10 | Firmas digitales e integridad | | ✅ |
| 11 | Comunicación asíncrona | | ✅ |
| 12 | Pipeline DevSecOps | | ✅ |
| 13 | Seguridad de contenedores | | ✅ |
| 14 | Evaluación de riesgos | | ✅ |
| 15 | Disponibilidad y continuidad | | ✅ |
| 16 | Uso de IA | | ✅ |
| 17 | Reflexión final | | ✅ |
| 18 | Anexo A — Diagrama de arquitectura (se regenera con `../1-diagrama-arquitectura/exportar.sh`) | | ✅ |

⬜ Sin empezar · 🟨 En progreso · 🟦 En revisión · ✅ Listo

## Las preguntas obligatorias

El enunciado hace **siete preguntas directas** que deben quedar respondidas de forma
explícita. Es lo más fácil de perder y lo más fácil de comprobar:

| Pregunta | Sección | ¿Respondida? |
| --- | --- | --- |
| ¿Por qué no basta HTTPS si la BD puede ser comprometida? | 06 | ✅ |
| ¿Por qué no cifrado reversible para contraseñas? | 07 | ✅ |
| ¿Por qué las claves no van en el código fuente? | 08 | ✅ |
| ¿Cómo se evita un webhook de pago falso? | 09 | ✅ |
| ¿Por qué firmar no es cifrar? | 10 | ✅ |
| ¿Qué pasa si un atacante publica mensajes falsos en la cola? | 11 | ✅ |
| Si cae catálogo, ¿por qué no debe alcanzar la BD de usuarios/pagos? | 13 | ✅ |
| ¿Por qué no aplicar automáticamente lo que recomiende una IA? | 17 | ✅ |

## Construir el documento

```bash
./construir.sh
```

Genera `documento-tecnico.md` concatenando las secciones en orden. Si tienes `pandoc` y
Chromium/Chrome, genera también el PDF (sin el encabezado automático de Chrome) e imprime
cuántas páginas tiene.

> El archivo construido **no se versiona** (está en `.gitignore` local): la fuente de verdad
> son los archivos de `secciones/`.
