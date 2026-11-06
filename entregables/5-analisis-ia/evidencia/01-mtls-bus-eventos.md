# Evidencia de consulta a IA — 01: mTLS en Bus de Eventos

**Herramienta:** Claude 3.5 Sonnet / Gemini 1.5 Pro  
**Fecha:** 2026-11-05  
**Quién la hizo:** Ian Alejandro Arroyo Ramírez  
**Para qué sección:** Entregable 5 / Sección 11 (Comunicación Asíncrona)

---

## Prompt utilizado
```text
Actúa como un Auditor Senior de Ciberseguridad Cloud. En una arquitectura de microservicios en Amazon EKS con mTLS en REST, ¿es suficiente el cifrado en reposo SSE-KMS en la cola de Amazon SQS / Kafka para garantizar la integridad y autenticidad de los eventos asíncronos entre servicios?
```

## Fragmento relevante de la respuesta
> "No es suficiente. SSE-KMS solo protege los mensajes en reposo en los discos de AWS. Si un pod no transaccional se ve comprometido dentro de la VPC, podría inyectar mensajes en la cola si no hay políticas de IAM a nivel de recurso o interceptar eventos si el canal no exige mTLS / TLS autenticado por pod."

## Análisis crítico del equipo
La observación es técnicamente certera. En un modelo Zero Trust, el canal interno entre el microservicio y el broker de mensajería debe estar autenticado criptográficamente por pod y restringido en permisos de escritura.

## Decisión final
✅ **Aceptada**

**Justificación:** Se incorporaron políticas IAM mínimas por pod (IRSA) donde solo el servicio de Pedidos puede publicar en la cola de órdenes, y se añadió la firma HMAC-SHA256 del cuerpo del evento en la cabecera `X-Event-Signature`.

**Qué cambió en el proyecto:** Sección 11 y tabla de trazabilidad de la matriz de riesgos.
