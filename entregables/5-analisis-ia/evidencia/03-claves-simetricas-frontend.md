# Evidencia de consulta a IA — 03: Claves Simétricas en Frontend

**Herramienta:** Claude 3.5 Sonnet / Gemini 1.5 Pro  
**Fecha:** 2026-11-05  
**Quién la hizo:** Violeta  
**Para qué sección:** Entregable 5 / Sección 16 y 17 (Reflexión Final)

---

## Prompt utilizado
```text
Para maximizar el rendimiento y la privacidad en un e-commerce, ¿es una buena práctica enviar una clave simétrica AES al frontend web para que el navegador descifre localmente el recibo de compra?
```

## Fragmento relevante de la respuesta
> "Sí, distribuir claves simétricas derivadas a la sesión del navegador permite descargar el procesamiento criptográfico del servidor y aplicar cifrado de extremo a extremo (E2EE) directamente en la máquina del usuario mediante la Web Crypto API."

## Análisis crítico del equipo
La recomendación es peligrosa y técnicamente errónea en un entorno web. El navegador del cliente es un entorno no confiable (*Zero Trust*). Entregar claves simétricas al frontend permite su extracción mediante ataques XSS, inspección en consola de desarrollador o extensiones maliciosas. La confidencialidad cliente-servidor se resuelve de forma estándar y segura con TLS 1.3 sin exponer claves maestras.

## Decisión final
❌ **Rechazada Categóricamente**

**Justificación:** Representa un claro ejemplo de alucinación o mala recomendación de seguridad por parte de una IA que no pondera el modelo de amenazas de aplicaciones web.

**Qué cambió en el proyecto:** Se documentó como argumento central en la Sección 17 sobre por qué una organización nunca debe aplicar a ciegas lo que sugiera una IA.
