# 17. Reflexión Final: Límites de la Inteligencia Artificial en Ciberseguridad

Aunque los LLMs ayudan a analizar y sugerir defensas, **un equipo de ingeniería jamás debe aplicar las recomendaciones de una IA a ciegas en su arquitectura**:

1. **Contexto Real y Rendimiento:** La IA suele sugerir ideales teóricos sin pensar en latencia ni costos de nube. Pedir firmas síncronas para cada lectura del catálogo tiraría la tienda en temporada de descuentos.
2. **Alucinaciones con Mucha Seguridad:** Los modelos inventan opciones o configuraciones inexistentes con total seguridad, lo que puede meter huecos de seguridad sin que nadie se dé cuenta.
3. **Desconexión con la Nube Moderna:** Suele dar recetas viejas pensadas para un solo servidor físico, ignorando cómo funcionan los contenedores y los service mesh como Istio.
4. **Bloqueo Involuntario de Usuarios:** Reglas de WAF demasiado estrictas sugeridas por IA pueden terminar bloqueando compras legítimas durante ventas nocturnas, costando mucho dinero.
5. **La Seguridad se Trata de Gestionar Riesgos:** No existe la seguridad al 100%; la ingeniería exige balancear costo, velocidad y protección, algo que un modelo de lenguaje no puede decidir.
6. **Responsabilidad Legal Real:** Normas como GDPR, PCI-DSS o la ley mexicana hacen responsables a las personas y a la empresa. Ningún juez o auditor va a aceptar como excusa que *"la vulnerabilidad la recomendó una IA"*.

La IA debe usarse como un **copiloto de apoyo**. La decisión final, el contexto y la responsabilidad siempre deben ser del ingeniero.
