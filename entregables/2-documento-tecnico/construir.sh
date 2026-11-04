#!/usr/bin/env bash
# Concatena las secciones del documento técnico en un solo archivo.
# Uso: ./construir.sh
set -euo pipefail
cd "$(dirname "$0")"

SALIDA="documento-tecnico.md"

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
fi

if command -v pandoc >/dev/null 2>&1; then
  echo "→ Generando PDF con pandoc..."
  pandoc "$SALIDA" -o documento-tecnico.pdf \
    -V geometry:margin=2.5cm -V fontsize=11pt -V lang=es 2>/dev/null \
    && echo "   ✓ documento-tecnico.pdf" \
    || echo "   ⚠️  pandoc falló (¿falta una distribución de LaTeX?). El .md está listo igualmente."
else
  echo "→ pandoc no está instalado; solo se generó el .md."
  echo "   Instalar con: brew install pandoc basictex"
fi
