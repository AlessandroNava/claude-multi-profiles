# Configurazione Multi-Account Claude Code su macOS e Linux

Questa guida contiene gli script Bash/Zsh necessari per configurare lo switch dei profili sui sistemi basati su Unix.

---

## 1. Passo 1: Inizializzazione e Migrazione
*   **Nome File:** `init-claude-personal.sh`
*   **Istruzioni:** Chiudi **VS Code**. Apri il terminale, rendi lo script eseguibile ed eseguilo.

```bash
#!/bin/bash

FOLDERS=(
    "Core:\(HOME/.claude:\)HOME/.claude-personal"
    "Memory:\(HOME/.claude-mem:\)HOME/.claude-mem-personal"
    "GUI:\(HOME/.claude-code-gui:\)HOME/.claude-code-gui-personal"
)

echo "Inizio migrazione delle cartelle Claude per il profilo PERSONAL..."
echo "---------------------------------------------------------"

for entry in "\${FOLDERS[@]}"; do
    IFS=":" read -r name old_path new_path <<< "\$entry"
    if [ -d "\(old_path" ] && [ ! -L "\)old_path" ]; then
        if [ -d "\$new_path" ]; then
            echo "[!] Attenzione: '\$new_path' esiste già. Salto la rinomina."
        else
            mv "\(old_path" "\)new_path"
            echo "[✓] \(name migrata con successo in:\)new_path"
        fi
    fi
done

# Spostamento file MCP globale .claude.json
if [ -f "\(HOME/.claude.json" ] && [ ! -L "\)HOME/.claude.json" ]; then
    mv "\(HOME/.claude.json" "\)HOME/.claude-personal.json"
    echo "[✓] File MCP globale migrato in ~/.claude-personal.json"
fi

# Copia i comandi/regole esistenti nel profilo lavoro per comodità
mkdir -p "\$HOME/.claude-work"
for item in commands skills CLAUDE.md; do
    if [ -e "\(HOME/.claude-personal/\)item" ]; then
        cp -r "\$HOME/.claude-personal/\(item" "\)HOME/.claude-work/"
        echo "[➔] Copiato '\$item' nel profilo lavoro."
    fi
done

echo "---------------------------------------------------------"
echo "[COMPLETATO] Esegui ora setup-claude-profiles.sh"
```
*Comando d'esecuzione:*
```bash
chmod +x init-claude-personal.sh && ./init-claude-personal.sh
```

---

## 2. Passo 2: Aggiornamento della Shell Zsh
*   **Nome File:** `setup-claude-profiles.sh`
*   **Istruzioni:** Esegui lo script per inserire in modo permanente le funzioni in fondo al tuo file `~/.zshrc`.

```bash
#!/bin/bash

echo "Scrittura delle funzioni all'interno di ~/.zshrc..."

cat << 'EOF' >> "\$HOME/.zshrc"

# === CONFIGURAZIONE AVANZATA MULTI-ACCOUNT CLAUDE ===
set-claude-profile() {
    local target=\$1
    
    # Rimozione sicura dei link simbolici precedenti
    rm -f "\(HOME/.claude" "\)HOME/.claude-mem" "\(HOME/.claude-code-gui" "\)HOME/.claude.json"

    if [ "\$target" = "personal" ]; then
        mkdir -p "\$HOME/.claude-personal"
        ln -s "\(HOME/.claude-personal" "\)HOME/.claude"
        ln -s "\(HOME/.claude-mem-personal" "\)HOME/.claude-mem" 2>/dev/null || true
        ln -s "\(HOME/.claude-code-gui-personal" "\)HOME/.claude-code-gui" 2>/dev/null || true
        [ -f "\$HOME/.claude-personal.json" ] && ln -s "\(HOME/.claude-personal.json" "\)HOME/.claude.json"
        echo -e "\033[0;36m[⇄] Profilo attivo: PERSONAL (Pro + MCP)\033[0m"
        
    elif [ "\$target" = "work" ]; then
        mkdir -p "\$HOME/.claude-work" "\(HOME/.claude-mem-work" "\)HOME/.claude-code-gui-work"
        [ ! -f "\(HOME/.claude-work.json" ] && echo "{}" > "\)HOME/.claude-work.json"
        
        ln -s "\(HOME/.claude-work" "\)HOME/.claude"
        ln -s "\(HOME/.claude-mem-work" "\)HOME/.claude-mem"
        ln -s "\(HOME/.claude-code-gui-work" "\)HOME/.claude-code-gui"
        ln -s "\(HOME/.claude-work.json" "\)HOME/.claude.json"
        echo -e "\033[0;35m[⇄] Profilo attivo: WORK (Team + MCP)\033[0m"
    fi
}

# Alias evoluti per attivare il profilo e lanciare la CLI con un solo comando
claude-personal() { set-claude-profile "personal"; claude "\$@"; }
claude-work()     { set-claude-profile "work"; claude "\$@"; }
# ==================================================================
EOF

echo "[✓] Configurazione salvata! Esegui 'source ~/.zshrc' per attivarla subito."
```
*Comando d'esecuzione:*
```bash
chmod +x setup-claude-profiles.sh && ./setup-claude-profiles.sh && source ~/.zshrc
```
