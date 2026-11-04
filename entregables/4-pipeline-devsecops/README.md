# Entregable 4 — Diseño del pipeline DevSecOps

> **Responsable:** _por asignar_ · **Estado:** ⬜ Sin empezar

## Qué pide el examen

Diseñar un pipeline seguro para desarrollar y desplegar los microservicios, sobre el flujo:

```
Desarrollador → Repositorio Git → Build → Pruebas → Análisis de seguridad
             → Creación de imagen → Despliegue
```

Controles mínimos obligatorios:

- [ ] revisión de código
- [ ] análisis estático (SAST)
- [ ] análisis de dependencias (SCA)
- [ ] detección de secretos
- [ ] análisis de imágenes de contenedores
- [ ] pruebas automatizadas
- [ ] control de acceso
- [ ] manejo seguro de secretos
- [ ] aprobación antes de producción

> **Lo que de verdad se evalúa:** *"Explica en qué punto del pipeline colocarías cada
> control"*. No es una lista de herramientas — es **dónde** va cada control y **por qué ahí**.
> Un escaneo de secretos en el *commit* no es lo mismo que en el *deploy*, y esa diferencia
> es la respuesta.

## Archivo de trabajo

[`pipeline-devsecops.md`](pipeline-devsecops.md)
