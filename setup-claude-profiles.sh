#!/bin/bash

SHELL_RC="$HOME/.zshrc"
[ ! -f "$SHELL_RC" ] && SHELL_RC="$HOME/.bashrc"

echo "Configurazione profili in $SHELL_RC..."

# Rimuove vecchi alias se presenti per evitare duplicati
sed -i.bak '/claude-personal/d' "$SHELL_RC" 2>/dev/null || sed -i '' '/claude-personal/d' "$SHELL_RC"
sed -i.bak '/claude-work/d' "$SHELL_RC" 2>/dev/null || sed -i '' '/claude-work/d' "$SHELL_RC"

# Aggiunge i nuovi alias basati su CLAUDE_CONFIG_DIR
echo "alias claude-personal='export CLAUDE_CONFIG_DIR=\"\$HOME/.claude-personal\" && claude'" >> "$SHELL_RC"
echo "alias claude-work='export CLAUDE_CONFIG_DIR=\"\$HOME/.claude-work\" && claude'" >> "$SHELL_RC"

echo "🎉 Setup completato! Riavvia il terminale o esegui: source $SHELL_RC"
