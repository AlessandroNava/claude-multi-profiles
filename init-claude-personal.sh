#!/bin/bash
FOLDERS=(
    "Core:$HOME/.claude:$HOME/.claude-personal"
    "Memory:$HOME/.claude-mem:$HOME/.claude-mem-personal"
    "GUI:$HOME/.claude-code-gui:$HOME/.claude-code-gui-personal"
)

echo "Inizio migrazione delle cartelle Claude per il profilo PERSONAL..."
for entry in "${FOLDERS[@]}"; do
    IFS=":" read -r name old_path new_path <<< "$entry"
    [ -d "$old_path" ] && [ ! -L "$old_path" ] && mv "$old_path" "$new_path" && echo "[✓] $name migrata."
done

# Gestione File MCP globale .claude.json
[ -f "$HOME/.claude.json" ] && [ ! -L "$HOME/.claude.json" ] && mv "$HOME/.claude.json" "$HOME/.claude-personal.json" && echo "[✓] File MCP migrato."

# Copia i comandi/regole esistenti nel profilo lavoro
mkdir -p "$HOME/.claude-work"
for item in commands skills CLAUDE.md; do
    [ -e "$HOME/.claude-personal/$item" ] && cp -r "$HOME/.claude-personal/$item" "$HOME/.claude-work/"
done
echo "[COMPLETATO] Allineamento iniziale eseguito."
