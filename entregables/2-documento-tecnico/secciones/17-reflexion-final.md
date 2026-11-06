# 17. Reflexión Final: Límites de la Inteligencia Artificial en Ciberseguridad

Los LLMs ayudan a revisar diseños y proponer defensas, pero **una organización no debe aplicar automáticamente todo lo que recomienda una IA**:

1. **Contexto:** La IA sólo conoce lo que se le muestra; una recomendación correcta en general puede no aplicar al sistema concreto.
2. **Falsos positivos:** Los modelos marcan como vulnerables cosas que no lo son (una dependencia con una CVE en una función que nunca se llama, un "secreto" que es un ID público). Atenderlos sin verificar introduce cambios innecesarios y acostumbra al equipo a ignorar alertas.
3. **Alucinaciones:** Pueden inventar parámetros o configuraciones inexistentes con total convicción.
4. **Configuración real del sistema:** Una sugerencia pensada para un servidor tradicional puede ser imposible en un servicio gestionado (por ejemplo, mTLS en SQS) o romper la integración con Istio.
5. **Impacto operativo:** Reglas de WAF demasiado estrictas o firmas en cada lectura del catálogo pueden bloquear compras legítimas o tirar la tienda en temporada alta.
6. **Gestión de riesgos:** No existe la seguridad al 100%. Decidir qué riesgo se mitiga, transfiere o acepta depende del costo y del negocio, como hicimos en la sección 14; un modelo no tiene esa información.
7. **Responsabilidad humana:** PCI-DSS, la LFPDPPP o el GDPR responsabilizan a la empresa y a sus personas. Ningún auditor acepta "lo recomendó una IA" como justificación.

La IA es un **copiloto**: propone y acelera la revisión. La decisión final, su contexto y su responsabilidad son del equipo.
