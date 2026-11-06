#!/usr/bin/env bash
# Exporta el diagrama Mermaid a PNG y SVG.
# Uso: ./exportar.sh
set -euo pipefail
cd "$(dirname "$0")"

mkdir -p exportados

CHROME_BIN=$(command -v chromium || command -v google-chrome || true)

if [ -n "$CHROME_BIN" ]; then
  echo "→ Exportando arquitectura.mmd con Chromium ($CHROME_BIN)..."
  PUPPETEER_EXECUTABLE_PATH="$CHROME_BIN" npx --yes @mermaid-js/mermaid-cli -i arquitectura.mmd -o exportados/arquitectura.png -b white
  PUPPETEER_EXECUTABLE_PATH="$CHROME_BIN" npx --yes @mermaid-js/mermaid-cli -i arquitectura.mmd -o exportados/arquitectura.svg
  echo "   ✓ exportados/arquitectura.png generado."
  echo "   ✓ exportados/arquitectura.svg generado."
else
  echo "→ Se requiere chromium o google-chrome para exportar diagramas localmente."
  echo "   También puedes pegar el contenido de arquitectura.mmd en https://mermaid.live"
fi
