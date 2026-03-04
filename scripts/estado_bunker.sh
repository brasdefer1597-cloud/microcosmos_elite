#!/bin/bash
# Ruta a tus datos
MONEY=~/microcosmos_elite/data/money.log
TELEMETRY=~/microcosmos_elite/data/telemetry.jsonl

# Si no existen, creamos archivos vacíos para que no den error
touch $MONEY $TELEMETRY

# Sumar dinero
TOTAL_DINERO=$(awk -F',' '{sum+=$1} END {print sum}' $MONEY)
if [ -z "$TOTAL_DINERO" ]; then TOTAL_DINERO=0; fi

# Contar datos
TOTAL_DATOS=$(wc -l < $TELEMETRY)

echo "💰 Dinero Total (LTV): \$$TOTAL_DINERO"
echo "🌌 Datos Generados (Entropía): $TOTAL_DATOS eventos"
