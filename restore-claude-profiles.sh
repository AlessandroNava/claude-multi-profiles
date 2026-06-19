#!/bin/bash

BASE_DIR="$HOME"
SUFFIX_P="-personal"
SUFFIX_W="-work"
LOG_FILE="$HOME/Desktop/Claude_Migration_Log.txt"

OLD_DIR="$BASE_DIR/.claude"
PERS_DIR="$BASE_DIR/.claude$SUFFIX_P"
WORK_DIR="$BASE_DIR/.claude$SUFFIX_W"

write_log() {
    local message="$1"
    local color="$2"
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    case "$color" in
        "green")  echo -e "\033[0;32m$message\033[0m" ;;
        "yellow") echo -e "\033[0;33m$message\033[0m" ;;
        "cyan")    echo -e "\033[0;36m$message\033[0m" ;;
        *)         echo "$message" ;;
    esac
    echo "[ $Timestamp ] $message" >> "$LOG_FILE"
}

clear
write_log "=== RIPRISTINO CONFIGURAZIONE ORIGINALE ===" "yellow"
read -p "Vuoi unificare i profili e tornare alla configurazione nativa? (S/N): " confirmation

if [[ ! "$confirmation" =~ ^[sSyY]$ ]]; then
    write_log "Operazione annullata." "cyan"
    exit 0
fi

write_log "=== INIZIO RIPRISTINO MANUALE ===" "cyan"

# Rimuove il symlink dell'estensione se presente (su Unix -L controlla se è un symlink)
if [ -L "$OLD_DIR" ]; then
    rm "$OLD_DIR"
    write_log "[✓] Rimosso il collegamento simbolico dell'estensione." "green"
fi

# Ripristina Personal come cartella principale fisica
if [ -d "$PERS_DIR" ] && [ ! -e "$OLD_DIR" ]; then
    mv "$PERS_DIR" "$OLD_DIR"
    write_log "[✓] Profilo Personal ripristinato come cartella fisica principale (.claude)." "green"
fi

# Elimina la cartella Work
if [ -d "$WORK_DIR" ]; then
    rm -rf "$WORK_DIR"
    write_log "[✓] Cartella profilo Work eliminata." "green"
fi

write_log "=== RIPRISTINO COMPLETATO ===" "green"