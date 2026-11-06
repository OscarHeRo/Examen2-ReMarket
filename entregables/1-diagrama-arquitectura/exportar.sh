#!/usr/bin/env bash
# Exporta el diagrama Mermaid a PNG (alta resolución) y SVG.
# Uso: ./exportar.sh
set -euo pipefail
cd "$(dirname "$0")"

mkdir -p exportados

CHROME_BIN=$(command -v chromium || command -v google-chrome || true)

if [ -z "$CHROME_BIN" ]; then
  echo "→ Se requiere chromium o google-chrome para exportar diagramas localmente."
  echo "   También puedes pegar el contenido de arquitectura.mmd en https://mermaid.live"
  exit 1
fi

# Chrome headless necesita --no-sandbox en contenedores y en algunas distros.
PUPPETEER_CFG=$(mktemp)
trap 'rm -f "$PUPPETEER_CFG"' EXIT
echo '{"args":["--no-sandbox"]}' > "$PUPPETEER_CFG"

MMDC=(npx --yes @mermaid-js/mermaid-cli@11.4.2 -p "$PUPPETEER_CFG" -i arquitectura.mmd)
export PUPPETEER_EXECUTABLE_PATH="$CHROME_BIN" PUPPETEER_SKIP_DOWNLOAD=1

echo "→ Exportando arquitectura.mmd con $CHROME_BIN..."
# -s 3: escala x3 para que el texto se lea al imprimir el documento técnico.
"${MMDC[@]}" -o exportados/arquitectura.png -b white -s 3
"${MMDC[@]}" -o exportados/arquitectura.svg -b white
cp exportados/arquitectura.png exportados/arquitectura.svg ../2-documento-tecnico/imagenes/
echo "   ✓ exportados/arquitectura.{png,svg} generados y copiados a 2-documento-tecnico/imagenes/"
