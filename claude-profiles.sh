#!/bin/bash

# Profilo Personale / Privato (Usa la cartella predefinita, condivisa con VS Code)
claude-personal() {
    unset CLAUDE_CONFIG_DIR
    claude "$@"
}

# Profilo di Lavoro / Team (Deviato sulla cartella isolata)
claude-work() {
    export CLAUDE_CONFIG_DIR="$HOME/.claude-work"
    claude "$@"
}
