# 10. Firmas Digitales e Integridad (Facturas y Comprobantes)

Los comprobantes de compra y facturas electrónicas requieren garantizar autenticidad, integridad y no repudio ante clientes, empresas de paquetería y autoridades tributarias (SAT). A diferencia de los datos confidenciales que se cifran para ocultar su contenido, los recibos fiscales deben permanecer en texto claro y legible para permitir su consulta inmediata; la protección radica en asegurar criptográficamente que los importes o productos no puedan ser alterados y que ReMarket no pueda desconocer su emisión.

### Flujo Criptográfico: Emisión y Verificación Universal
El proceso de generación y validación de comprobantes se estructura en cinco etapas criptográficas:

1. **Estructuración del Documento ($M$):** El microservicio de facturación genera el comprobante en formato estándar (XML conforme a lineamientos fiscales / PDF estructurado).
2. **Generación del Resumen Criptográfico:** Se calcula el hash mediante **SHA-256**:
   $$h = \text{SHA-256}(M)$$
   Cualquier modificación posterior en importes, fechas o productos alterará de forma irreversible el resumen resultante.
3. **Firma Asimétrica en Hardware Seguro:** La clave privada institucional de ReMarket, custodiada de forma no exportable en **AWS CloudHSM** (**FIPS 140-2 Nivel 3**), firma el resumen utilizando **ECDSA P-256**:
   $$\sigma = \text{Sign}_{sk}(h)$$
   La operación se ejecuta dentro del módulo criptográfico sin exponer la clave privada a la memoria del microservicio.
4. **Empaquetado con Certificado X.509:** Se adjuntan la firma digital $\sigma$ y el certificado digital **X.509** público emitido por una Autoridad Certificadora reconocida.
5. **Verificación Universal:** Cualquier entidad externa (consumidor, pasarela de pago o auditoría fiscal) puede validar de forma independiente la integridad y procedencia del comprobante aplicando la clave pública $pk$ contenida en el certificado:
   $$\text{Verify}_{pk}(\text{SHA-256}(M), \sigma) \stackrel{?}{=} \text{true}$$
   Si el documento sufre cualquier alteración, la verificación falla de inmediato, garantizando no repudio pleno sin depender de canales confidenciales adicionales.
