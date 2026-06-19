#!/bin/bash

# Configurazione percorsi
BASE_DIR="$HOME"
SUFFIX_P="-personal"
SUFFIX_W="-work"
LOG_FILE="$HOME/Desktop/Claude_Migration_Log.txt"

PERS_DIR="$BASE_DIR/.claude$SUFFIXP"
WORK_DIR="$BASE_DIR/.claude$SUFFIX_W"
HANDOFF_FOLDER="$PERS_DIR/skills/handoff"
HANDOFF_FILE="$HANDOFF_FOLDER/SKILL.md"

# Funzione di logging centralizzata
write_log() {
    local message="$1"
    local color="$2"
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    # Gestione colori nel terminale Unix
    case "$color" in
        "green")  echo -e "\033[0;32m$message\033[0m" ;;
        "yellow") echo -e "\033[0;33m$message\033[0m" ;;
        "magenta") echo -e "\033[0;35m$message\033[0m" ;;
        "cyan")    echo -e "\033[0;36m$message\033[0m" ;;
        *)         echo "$message" ;;
    esac
    
    echo "[ $timestamp ] $message" >> "$LOG_FILE"
}

clear
write_log "=== CONFIGURAZIONE PROFILI CLAUDE ===" "cyan"
read -p "Vuoi procedere? (S/N): " confirmation

if [[ ! "$confirmation" =~ ^[sSyY]$ ]]; then
    write_log "Operazione annullata." "yellow"
    exit 0
fi

echo "=== INIZIO CONFIGURAZIONE ===" > "$LOG_FILE"

# Chiusura processi attivi (Claude Code o Desktop)
write_log "Chiusura processi Claude attivi..." "yellow"
pkill -f "claude" 2>/dev/null
pkill -f "claude-code" 2>/dev/null
sleep 2

# Creazione cartella Personal
if [ ! -d "$PERS_DIR" ]; then
    mkdir -p "$PERS_DIR"
    write_log "[OK] Cartella Personale creata: $PERS_DIR" "green"
else
    write_log "[INFO] Cartella Personale gia esistente."
fi

# Creazione cartella Work
if [ ! -d "$WORK_DIR" ]; then
    mkdir -p "$WORK_DIR"
    write_log "[OK] Cartella Work creata: $WORK_DIR" "green"
else
    write_log "[INFO] Cartella Work gia esistente."
fi

# Auto-installazione skill Handoff se assente
if [ ! -f "$HANDOFF_FILE" ]; then
    write_log "[i] Skill handoff assente. Installazione automatica..." "yellow"
    mkdir -p "$HANDOFF_FOLDER"
    
    cat << 'EOF' > "$HANDOFF_FILE"
---
name: handoff
description: Use this skill when the user asks to save, pause, or transfer the current chat session context to another profile or agent.
---

# Session Handoff Skill

When this skill is triggered, you must help the user transition their current workspace state to a new session by creating a summary file.

## Instructions
1. Scan the recent chat history, active branch, and modified files in the repository.
2. Generate a compact status update containing:
   - **Current Goal**: What task is currently in progress.
   - **Accomplished**: What has already been coded or completed.
   - **Next Steps**: Explicit checklist of what the next profile needs to do.
   - **Continuation Prompt**: A copy-pasteable paragraph that summarizes everything for the next session.
3. Save this summary as 'HANDOFF.md' in the project root folder.
4. Output the continuation prompt clearly in the chat response.
EOF
    write_log "[✓] Skill handoff installata nel profilo Personal." "green"
fi

# Copia elementi da Personal a Work
ITEMS_TO_COPY=("commands" "skills" "CLAUDE.md")
for item in "${ITEMS_TO_COPY[@]}"; do
    if [ -e "$PERS_DIR/$item" ] && [ ! -e "$WORK_DIR/$item" ]; then
        cp -R "$PERS_DIR/$item" "$WORK_DIR/$item"
        write_log "[OK] Copiato elemento nel profilo Work: $item" "magenta"
    fi
done

write_log "=== OPERAZIONE COMPLETATA ===" "green"