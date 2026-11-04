# 9. Pasarela de pagos

> **Responsable:** _por asignar_ · **Estado:** ⬜ Sin empezar · **Extensión objetivo:** ~1 página

## Qué pide el examen

Diseñar el flujo **Usuario → ReMarket → Pasarela de pagos**. Identificar:

- qué datos recibe ReMarket
- qué datos deberían manejarse **directamente por la pasarela** (sin pasar por nosotros)
- qué información **no debería almacenarse** nunca
- qué comunicaciones deben protegerse
- cómo verificar que una respuesta proviene realmente del proveedor de pagos

### Caso obligatorio — el webhook

La pasarela envía:

```http
POST /payment-confirmed
```

> **¿Cómo evita ReMarket que un atacante envíe una solicitud falsa indicando que un pedido
> fue pagado?**

Proponer mecanismos de verificación concretos. Pensar en: firma del cuerpo, secreto
compartido, marca de tiempo, idempotencia, confirmación contra la API del proveedor,
restricción de origen. Y decir cuál se elige y por qué.

## Las cuatro preguntas del criterio de evaluación

Rellenar **antes** de redactar. Si no se pueden contestar las cuatro, la sección no está lista.

| | |
| --- | --- |
| **¿Qué se protege?** | |
| **¿Contra qué amenaza se protege?** | |
| **¿Qué propiedad criptográfica o control se necesita?** | |
| **¿Por qué la solución propuesta es adecuada?** | |

## Desarrollo

_Redactar aquí._

## Decisiones tomadas y alternativas descartadas

| Decisión | Alternativa descartada | Por qué |
| --- | --- | --- |
| | | |
