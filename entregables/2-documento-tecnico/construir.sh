#!/usr/bin/env bash
# Concatena las secciones del documento técnico en un solo archivo y genera el PDF.
# Uso: ./construir.sh
set -euo pipefail
cd "$(dirname "$0")"

SALIDA="documento-tecnico.md"
PDF_SALIDA="documento-tecnico.pdf"
HTML_SALIDA="documento-tecnico.html"
CSS_FILE="estilo-documento.css"

echo "→ Concatenando secciones..."
: > "$SALIDA"
for f in secciones/*.md; do
  echo "   · $f"
  cat "$f" >> "$SALIDA"
  printf '\n\n---\n\n' >> "$SALIDA"
done

PALABRAS=$(wc -w < "$SALIDA" | tr -d ' ')
PAGS=$(( PALABRAS / 500 ))
echo "→ $SALIDA generado: ${PALABRAS} palabras (≈ ${PAGS} páginas a 500 palabras/página)"

if [ "$PAGS" -gt 10 ]; then
  echo "   ⚠️  OJO: el límite del examen es 8–10 páginas. Hay que recortar."
else
  echo "   ✓ Extensión dentro del presupuesto del examen (máx. 10 páginas)."
fi

# Detectar navegador headless para renderizado HTML->PDF de alta fidelidad
CHROME_BIN=$(command -v chromium || command -v google-chrome || true)

# 1. Si pandoc está disponible, generar HTML con estilos CSS ejecutivos y compilar PDF
if command -v pandoc >/dev/null 2>&1; then
  echo "→ Compilando con Pandoc y estilos tipográficos..."
  pandoc -s -c "$CSS_FILE" "$SALIDA" -o "$HTML_SALIDA" --metadata title="ReMarket - Documento Técnico de Arquitectura y Seguridad"
  
  if [ -n "$CHROME_BIN" ]; then
    echo "→ Generando PDF de alta fidelidad mediante Chromium ($CHROME_BIN)..."
    "$CHROME_BIN" --headless --disable-gpu --run-all-compositor-stages-before-draw --print-to-pdf="$PDF_SALIDA" "$HTML_SALIDA" >/dev/null 2>&1
    echo "   ✓ $PDF_SALIDA generado exitosamente."
    exit 0
  fi
fi

# 2. Si pandoc no está disponible pero sí Python y Chromium
if [ -n "$CHROME_BIN" ]; then
  echo "→ Generando PDF mediante Python Markdown + $CHROME_BIN..."
  python3 - << 'PYEOF'
import markdown

with open("documento-tecnico.md", "r", encoding="utf-8") as f:
    md_text = f.read()

html_body = markdown.markdown(md_text, extensions=['tables', 'fenced_code', 'toc'])

with open("estilo-documento.css", "r", encoding="utf-8") as f:
    css = f.read()

with open("documento-tecnico.html", "w", encoding="utf-8") as f:
    f.write(f"<!DOCTYPE html><html lang='es'><head><meta charset='utf-8'><title>ReMarket - Documento Técnico</title><style>{css}</style></head><body>{html_body}</body></html>")
PYEOF

  "$CHROME_BIN" --headless --disable-gpu --run-all-compositor-stages-before-draw --print-to-pdf="$PDF_SALIDA" "$HTML_SALIDA" >/dev/null 2>&1
  echo "   ✓ $PDF_SALIDA generado exitosamente."
  exit 0
fi

# 3. Fallback con motor LaTeX si no hay Chromium
if command -v pandoc >/dev/null 2>&1; then
  echo "→ Intentando compilar PDF con motor LaTeX..."
  if echo '\documentclass{article}\begin{document}x\end{document}' | xelatex -interaction=batchmode >/dev/null 2>&1; then
    pandoc "$SALIDA" -o "$PDF_SALIDA" --pdf-engine=xelatex -V geometry:margin=2.5cm -V fontsize=11pt -V lang=es 2>/dev/null && {
      echo "   ✓ $PDF_SALIDA generado exitosamente con XeLaTeX."
      exit 0
    }
  fi
fi

echo "⚠️  No se encontró un motor de PDF compatible."
echo "   Para habilitar la generación de PDF en Arch Linux, ejecuta:"
echo "     sudo pacman -S chromium"
echo "   O para el motor LaTeX:"
echo "     sudo pacman -S texlive-xetex"
