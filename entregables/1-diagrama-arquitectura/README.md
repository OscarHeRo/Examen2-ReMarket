# Entregable 1 — Diagrama de arquitectura cloud

> **Responsable:** _por asignar_ · **Estado:** ⬜ Sin empezar

## Qué se entrega

Un diagrama donde se identifiquen **claramente**:

- [ ] Usuarios
- [ ] Servicios
- [ ] Microservicios
- [ ] Bases de datos
- [ ] Comunicaciones
- [ ] Servicios externos
- [ ] **Zonas de confianza**
- [ ] **Componentes de seguridad**

## Componentes mínimos obligatorios

| # | Componente | ¿En el diagrama? |
| --- | --- | --- |
| 1 | Frontend web | ⬜ |
| 2 | API Gateway / punto de entrada | ⬜ |
| 3 | Servicio de autenticación y usuarios | ⬜ |
| 4 | Servicio de catálogo | ⬜ |
| 5 | Servicio de pedidos | ⬜ |
| 6 | Servicio de inventario | ⬜ |
| 7 | Servicio de pagos | ⬜ |
| 8 | Servicio de notificaciones | ⬜ |
| 9 | Base de datos transaccional | ⬜ |
| 10 | BD / almacenamiento de catálogo | ⬜ |
| 11 | Caché | ⬜ |
| 12 | Cola o bus de eventos | ⬜ |
| 13 | Servicio externo de pagos | ⬜ |
| 14 | Servicio externo de paquetería | ⬜ |

Se pueden añadir más componentes **si se justifican** en el documento técnico.

## Decisión pendiente: ¿qué nube?

El examen permite **AWS, Azure, GCP o una arquitectura cloud genérica**. Hay que elegir una
y ser consistente en todo el documento.

- [ ] Nube elegida: _______________
- [ ] Justificación (una línea): _______________

> Sugerencia: *cloud genérica* evita tener que acertar nombres de servicios propietarios, y
> el examen evalúa el razonamiento, no el catálogo de productos. Si se elige un proveedor
> concreto, conviene nombrar los servicios reales (p. ej. KMS, Secret Manager, ALB).

## Archivos

| Archivo | Para qué |
| --- | --- |
| [`arquitectura.mmd`](arquitectura.mmd) | Borrador en Mermaid — versionable, se edita como texto |
| `exportados/` | PNG / PDF final que se entrega |

### Cómo trabajar el diagrama

**Opción A — Mermaid (recomendada para el borrador).** Se edita como texto, así que el
control de versiones y los *diff* funcionan. GitHub lo renderiza solo. Para exportar:
[mermaid.live](https://mermaid.live) → pegar el contenido de `arquitectura.mmd` → PNG/SVG.

**Opción B — draw.io / Lucidchart / Excalidraw** para la versión final si queremos más
control visual. Guardar el fuente editable (`.drawio`) **también** en esta carpeta, no solo
la imagen.

Decidir en equipo y anotarlo aquí: _______________

## Checklist antes de dar por cerrado el diagrama

- [ ] Los 14 componentes mínimos aparecen
- [ ] Las zonas de confianza están dibujadas como fronteras visibles, no solo mencionadas
- [ ] Cada flecha dice **con qué se protege** (TLS, mTLS, firma HMAC…)
- [ ] Se ve qué servicios **no** pueden hablar con la BD de usuarios/pagos
- [ ] Los componentes de seguridad (KMS, Secret Manager, WAF, IAM, SIEM) están presentes
- [ ] Exportado a `exportados/` en PDF o PNG legible
- [ ] Coincide con lo que dice el documento técnico (no describir una cosa y dibujar otra)
