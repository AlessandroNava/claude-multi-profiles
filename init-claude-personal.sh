#!/bin/bash
# Crea le directory isolate per i profili
mkdir -p "$HOME/.claude-personal"
mkdir -p "$HOME/.claude-work"

echo "✅ Cartelle di configurazione isolate create con successo!"
echo "Personale: $HOME/.claude-personal"
echo "Lavoro:    $HOME/.claude-work"
echo "Ora puoi configurare i tuoi profili separatamente in queste directory."