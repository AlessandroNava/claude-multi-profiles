#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[1/3] Salvataggio contesto corrente (Profilo PERSONAL)..."
claude -c "Usa la skill handoff per salvare la sessione del profilo personale prima dello switch"

echo "[2/3] Chiusura processi Claude..."
pkill -f "claude" 2>/dev/null
sleep 1

echo "[3/3] Configurazione e switch verso WORK..."
bash "$SCRIPT_DIR/init-claude-profiles.sh"
