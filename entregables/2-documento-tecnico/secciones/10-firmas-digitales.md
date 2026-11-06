# 10. Firmas Digitales e Integridad (Facturas y Comprobantes)

Los comprobantes de compra deben garantizar **integridad** (nadie cambió montos ni productos), **autenticidad** (los emitió ReMarket) y **no repudio** (ReMarket no puede negar haberlos emitido).

**Firmar no es cifrar.** Cifrar oculta el contenido para que sólo quien tiene la clave lo lea (confidencialidad). Firmar deja el documento **legible para todos** y le agrega una prueba, hecha con la clave privada del emisor, que cualquiera verifica con la clave pública. Un comprobante firmado se puede leer libremente; lo que no se puede es alterarlo sin que la verificación falle.

### Flujo: Documento → Hash → Firma → Verificación
1. **Documento ($M$):** El servicio de Pedidos genera el comprobante (XML o PDF).
2. **Hash:** $h = \text{SHA-256}(M)$. Cambiar un solo carácter produce un resumen completamente distinto.
3. **Firma:** La llave privada de ReMarket, custodiada **no exportable en CloudHSM**, firma el resumen con **ECDSA P-256**: $\sigma = \text{Sign}_{sk}(h)$. Pedidos pide la operación; la llave nunca llega a su memoria.
4. **Certificado:** Se adjuntan $\sigma$ y el certificado **X.509** de ReMarket, emitido por una CA, que liga la clave pública $pk$ con la identidad de la empresa.
5. **Verificación:** Cualquiera (cliente, auditor, paquetería) recalcula $\text{SHA-256}(M)$ y comprueba $\text{Verify}_{pk}(h, \sigma)$. Si el documento cambió, el hash cambia y la firma no valida.

**Facturas fiscales en México:** el CFDI 4.0 sigue el esquema del SAT: se sella con el Certificado de Sello Digital (CSD) del emisor (RSA con SHA-256) y luego lo timbra un PAC. El mismo flujo hash → firma → verificación aplica; sólo cambian el algoritmo y la CA (el SAT). La llave del CSD también se guarda en CloudHSM.
