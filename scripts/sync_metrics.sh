#!/bin/bash
ROOT="/home/chalamandramagistral/microcosmos_elite"
REPORT_CSV="$ROOT/data/informe_rendimiento.csv"

# 1. Hardware (si falla, valores default)
HW_RAW=$(python3 "$ROOT/scripts/metrics_engine.py" 2>/dev/null || echo '{"timestamp":"'$(date +%s)'","ejecucion_seg":0,"ram_mb_delta":0,"cpu_percent":0}')
TS=$(echo "$HW_RAW" | jq -r '.timestamp // "'$(date +%s)'"')
TIME=$(echo "$HW_RAW" | jq -r '.ejecucion_seg // 0')
RAM=$(echo "$HW_RAW" | jq -r '.ram_mb_delta // 0')
CPU=$(echo "$HW_RAW" | jq -r '.cpu_percent // 0')

# 2. Negocio (Grover)
BIZ_RAW=$(python3 "$ROOT/scripts/grover_engine.py" 2>/dev/null || echo '{"poas":0,"fidelidad":0,"mejor_campaña":0}')
POAS=$(echo "$BIZ_RAW" | jq -r '.poas // 0')
FID=$(echo "$BIZ_RAW" | jq -r '.fidelidad // 0')
IDX=$(echo "$BIZ_RAW" | jq -r '.mejor_campaña // 0')

# 3. Registro
echo "$TS,$TIME,$RAM,$CPU,$POAS,$FID,$IDX" >> "$REPORT_CSV"

# 4. JSON para frontend
JSON_DATA=$(jq -n \
  --arg ts "$TS" --arg tm "$TIME" --arg rm "$RAM" --arg cp "$CPU" \
  --arg ps "$POAS" --arg fd "$FID" --arg idx "$IDX" \
  '{
    timestamp: $ts,
    latencia_seg: ($tm | tonumber),
    ram_delta: ($rm | tonumber),
    cpu_uso: ($cp | tonumber),
    business: {
      poas: ($ps | tonumber),
      fidelidad: ($fd | tonumber),
      campana_ganadora: ($idx | tonumber),
      status: "NIRVANA_CODE"
    }
  }')

echo "$JSON_DATA" > "$ROOT/frontend/public/data/shor_stats.json"

echo "📊 Telemetría: CPU ${CPU}% | RAM Δ ${RAM}MB | POAS ${POAS}x | FID ${FID}% | Campaña #${IDX}"
