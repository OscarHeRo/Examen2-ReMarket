# Cómo trabajamos en este repositorio

Acuerdos del equipo para no pisarnos y para que la entrega sea coherente.

## 1. Una sección = un archivo = una rama

El documento técnico está partido en archivos pequeños
(`entregables/2-documento-tecnico/secciones/`) **a propósito**: así tres personas pueden
escribir al mismo tiempo sin conflictos de merge.

Regla: **no edites el archivo de una sección que no te toca.** Si ves algo que corregir
en la sección de alguien más, coméntalo en su Pull Request.

## 2. Ramas

Una rama por sección o por entregable:

```
seccion/05-api-rest
seccion/14-evaluacion-de-riesgos
entregable/1-diagrama
fix/typos-portada
```

```bash
git switch main
git pull
git switch -c seccion/05-api-rest
```

## 3. Commits

Formato: `tipo: ámbito — qué cambió`

| Tipo | Para qué |
| --- | --- |
| `doc:` | contenido de los entregables |
| `fix:` | correcciones, erratas |
| `estructura:` | mover archivos, plantillas, organización |
| `gestion:` | backlog, bitácora, asignaciones |

Ejemplos:

```
doc: contraseñas — Argon2id, salt y por qué no cifrado reversible
doc: matriz de riesgos — 3 riesgos de credenciales con tratamiento
fix: diagrama — faltaba la zona de confianza de la BD de pagos
```

## 4. Pull Requests

1. Abre PR contra `main`.
2. Pide revisión a **alguien más del equipo** (no se hace merge a lo propio sin revisar).
3. Quien revisa comprueba las **cuatro preguntas del criterio de evaluación**:
   - ¿qué se protege?
   - ¿contra qué amenaza?
   - ¿qué propiedad criptográfica o control se necesita?
   - ¿por qué esta solución es adecuada?
4. Si las cuatro están respondidas, aprueba y hace merge.

## 5. Antes de entregar

- [ ] Las cinco casillas de la tabla de entregables del `README.md` están en ✅
- [ ] El documento técnico **no pasa de 10 páginas** (el límite es 8–10)
- [ ] El diagrama está exportado a PDF/PNG en `entregables/1-diagrama-arquitectura/exportados/`
- [ ] La evidencia de IA (prompts + respuestas) está en `entregables/5-analisis-ia/evidencia/`
- [ ] Nadie subió credenciales reales (revisar con `git log -p | grep -i -E "api[_-]?key|password|secret"`)
- [ ] Los tres nombres completos aparecen en la portada

## 6. Nada de secretos reales

Es un examen de seguridad: que no nos pase a nosotros. Si hace falta ilustrar un token o
una clave, usa un valor obviamente falso (`EJEMPLO-NO-REAL-xxxx`). El `.gitignore` ya
bloquea `.env`, `*.pem` y `*.key`, pero el `.gitignore` no te salva si fuerzas el `git add`.
