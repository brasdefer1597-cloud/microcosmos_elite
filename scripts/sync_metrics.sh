#!/bin/bash
ROOT="/home/chalamandramagistral/microcosmos_elite"
REPORT_CSV="$ROOT/data/informe_rendimiento.csv"

# 1. Obtener Telemetría de Hardware
HW_RAW=$(python3 $ROOT/scripts/metrics_engine.py)
TS=$(echo $HW_RAW | jq -r '.timestamp')
TIME=$(echo $HW_RAW | jq -r '.ejecucion_seg')
RAM=$(echo $HW_RAW | jq -r '.ram_mb_delta')
CPU=$(echo $HW_RAW | jq -r '.cpu_percent')

# 2. Obtener Datos de Negocio (Grover)
BIZ_RAW=$(python3 $ROOT/scripts/grover_engine.py)
POAS=$(echo $BIZ_RAW | jq -r '.poas')
FID=$(echo $BIZ_RAW | jq -r '.fidelidad')
# Corregimos el nombre de la clave para evitar caracteres especiales
IDX=$(echo $BIZ_RAW | jq -r '.mejor_campaña // .mejor_campana // 6')

# 3. Registro Consolidado
echo "$TS,$TIME,$RAM,$CPU,$POAS,$FID,$IDX" >> $REPORT_CSV

# 4. Construcción del JSON con sintaxis de espacios correcta
# Nota: --arg [nombre] [valor]
JSON_DATA=$(jq -n \
  --arg ts "$TS" \
  --arg tm "$TIME" \
  --arg rm "$RAM" \
  --arg cp "$CPU" \
  --arg ps "$POAS" \
  --arg fd "$FID" \
  --arg idx "$IDX" \
  '{
    timestamp: $ts,
    latencia_seg: $tm,
    ram_delta: $rm,
    cpu_uso: $cp,
    business: {
      poas: ($ps | tonumber),
      fidelidad: ($fd | tonumber),
      campana_ganadora: ($idx | tonumber),
      status: "NIRVANA_CODE"
    }
  }')

echo "$JSON_DATA" > "$ROOT/frontend/public/data/shor_stats.json"

echo "📊 Telemetría: CPU ${CPU}% | RAM Delta: ${RAM}MB | Nirvana: ${FID}%"
