#!/usr/bin/env bash
# Arma la carpeta de entrega del Examen 2 con los 5 entregables en PDF/PNG y un ZIP.
# Uso: ./entrega/armar-entrega.sh
# Requiere: pandoc, Chromium/Chrome y npx (para el diagrama del pipeline).
set -euo pipefail
cd "$(dirname "$0")/.."

RAIZ=$(pwd)
ENT="$RAIZ/entregables"
SALIDA="$RAIZ/entrega/Examen2-ReMarket"
ZIP="$RAIZ/entrega/Examen2-ReMarket-entrega.zip"
CSS="$ENT/2-documento-tecnico/estilo-documento.css"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

CHROME_BIN=$(command -v chromium || command -v google-chrome || true)
[ -n "$CHROME_BIN" ] || { echo "⚠️  Se necesita chromium o google-chrome."; exit 1; }
command -v pandoc >/dev/null || { echo "⚠️  Se necesita pandoc."; exit 1; }

rm -rf "$SALIDA" "$ZIP"
mkdir -p "$SALIDA"

# Markdown -> PDF con el mismo estilo que el documento técnico.
# Quita las líneas internas de "Responsable / Estado" que sólo sirven para el equipo.
md_a_pdf() {
  local titulo="$1" md="$2" pdf="$3"
  sed -E '/^> \*\*Responsable:\*\*/d' "$md" > "$TMP/entrada.md"
  (cd "$(dirname "$md")" && pandoc -s --mathml --embed-resources --columns=10000 -c "$CSS" \
    "$TMP/entrada.md" -o "$TMP/salida.html" \
    --metadata pagetitle="$titulo" --metadata lang=es --resource-path=".:$TMP")
  "$CHROME_BIN" --headless --no-sandbox --disable-gpu --no-pdf-header-footer \
    --run-all-compositor-stages-before-draw --print-to-pdf="$pdf" "$TMP/salida.html" >/dev/null 2>&1
  echo "   ✓ $(basename "$pdf")"
}

echo "→ 1. Diagrama de arquitectura"
cp "$ENT/1-diagrama-arquitectura/exportados/arquitectura.png" "$SALIDA/1-diagrama-arquitectura.png"
cp "$ENT/1-diagrama-arquitectura/exportados/arquitectura.svg" "$SALIDA/1-diagrama-arquitectura.svg"
echo "   ✓ 1-diagrama-arquitectura.png / .svg"

echo "→ 2. Documento técnico"
"$ENT/2-documento-tecnico/construir.sh" >/dev/null
cp "$ENT/2-documento-tecnico/documento-tecnico.pdf" "$SALIDA/2-documento-tecnico.pdf"
echo "   ✓ 2-documento-tecnico.pdf"

echo "→ 3. Matriz de riesgos"
md_a_pdf "ReMarket - Matriz de Riesgos" "$ENT/3-matriz-riesgos/matriz-riesgos.md" "$SALIDA/3-matriz-de-riesgos.pdf"

echo "→ 4. Pipeline DevSecOps"
# El diagrama Mermaid del pipeline se convierte a imagen para que aparezca en el PDF.
awk '/^```mermaid/{f=1;next} /^```/{if(f){f=0;next}} f' "$ENT/4-pipeline-devsecops/pipeline-devsecops.md" > "$TMP/pipeline.mmd"
echo '{"args":["--no-sandbox"]}' > "$TMP/pp.json"
PUPPETEER_EXECUTABLE_PATH="$CHROME_BIN" PUPPETEER_SKIP_DOWNLOAD=1 \
  npx --yes @mermaid-js/mermaid-cli@11.4.2 -q -p "$TMP/pp.json" -i "$TMP/pipeline.mmd" -o "$TMP/pipeline.png" -b white -s 3 >/dev/null 2>&1
awk -v img="$TMP/pipeline.png" '/^```mermaid/{f=1; print "![Flujo del pipeline DevSecOps](" img ")"; next} /^```/{if(f){f=0;next}} !f' \
  "$ENT/4-pipeline-devsecops/pipeline-devsecops.md" > "$TMP/pipeline.md"
md_a_pdf "ReMarket - Pipeline DevSecOps" "$TMP/pipeline.md" "$SALIDA/4-pipeline-devsecops.pdf"

echo "→ 5. Análisis del uso de la IA"
{
  echo "# Análisis del Uso de la IA — ReMarket"
  echo
  sed -E '1s/^# /## /; s/^## /### /' "$ENT/5-analisis-ia/ia-como-atacante.md"
  echo; echo '<div style="page-break-before: always"></div>'; echo
  sed -E '1s/^# /## /; s/^## /### /' "$ENT/5-analisis-ia/ia-como-evaluador.md" \
    | sed 's#\[`evidencia/01-revision-arquitectura.md`\](evidencia/01-revision-arquitectura.md)#Anexo (al final de este documento)#'
  echo; echo '<div style="page-break-before: always"></div>'; echo
  sed -E '1s/^# 17\. /## /' "$ENT/2-documento-tecnico/secciones/17-reflexion-final.md"
  echo; echo '<div style="page-break-before: always"></div>'; echo
  sed -E '1s/^# /## Anexo — /; s/^## /### /' "$ENT/5-analisis-ia/evidencia/01-revision-arquitectura.md" \
    | sed 's#\[`../ia-como-evaluador.md`\](../ia-como-evaluador.md)#la sección "IA como Evaluador"#'
} > "$TMP/ia.md"
md_a_pdf "ReMarket - Análisis del Uso de la IA" "$TMP/ia.md" "$SALIDA/5-analisis-ia.pdf"

echo "→ Empaquetando ZIP"
(cd "$RAIZ/entrega" && zip -qr "$(basename "$ZIP")" "$(basename "$SALIDA")")
echo "   ✓ entrega/$(basename "$ZIP")"
ls -la "$SALIDA"
