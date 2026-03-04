#!/bin/bash
ROOT="/home/chalamandramagistral/microcosmos_elite"
DATA_FILE="$ROOT/data/informe_cuantico.csv"
JSON_OUT="$ROOT/frontend/public/data/history.json"

if [ -s "$DATA_FILE" ]; then
    # Filtramos líneas vacías antes de pasarlas a jq
    grep -v '^$' "$DATA_FILE" | tail -n 10 | jq -R -s '
      split("\n") | map(select(length > 0) | split(",")) | map({
        timestamp: .[0],
        ejecucion: .[1] | tonumber,
        ram: .[2] | tonumber,
        cpu: .[3] | tonumber,
        poas: .[4] | tonumber,
        fidelidad: .[5] | tonumber,
        campana: .[6] | tonumber
      })' > "$JSON_OUT"
    echo "💎 JSON purificado y generado en $JSON_OUT"
else
    echo "⚠️ Esperando datos del Oráculo..."
fi
