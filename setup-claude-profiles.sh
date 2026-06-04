#!/bin/bash
cat << 'EOF' >> "$HOME/.zshrc"

# === CONFIGURAZIONE AVANZATA MULTI-ACCOUNT CLAUDE ===
set-claude-profile() {
    local target=$1
    rm -f "$HOME/.claude" "$HOME/.claude-mem" "$HOME/.claude-code-gui" "$HOME/.claude.json"

    if [ "$target" = "personal" ]; then
        ln -s "$HOME/.claude-personal" "$HOME/.claude"
        ln -s "$HOME/.claude-mem-personal" "$HOME/.claude-mem" 2>/dev/null || true
        ln -s "$HOME/.claude-code-gui-personal" "$HOME/.claude-code-gui" 2>/dev/null || true
        [ -f "$HOME/.claude-personal.json" ] && ln -s "$HOME/.claude-personal.json" "$HOME/.claude.json"
        echo -e "\033[0;36m[⇄] Profilo: PERSONAL (Pro + MCP)\033[0m"
    elif [ "$target" = "work" ]; then
        mkdir -p "$HOME/.claude-work" "$HOME/.claude-mem-work" "$HOME/.claude-code-gui-work"
        [ ! -f "$HOME/.claude-work.json" ] && echo "{}" > "$HOME/.claude-work.json"
        
        ln -s "$HOME/.claude-work" "$HOME/.claude"
        ln -s "$HOME/.claude-mem-work" "$HOME/.claude-mem"
        ln -s "$HOME/.claude-code-gui-work" "$HOME/.claude-code-gui"
        ln -s "$HOME/.claude-work.json" "$HOME/.claude.json"
        echo -e "\033[0;35m[⇄] Profilo: WORK (Team + MCP)\033[0m"
    fi
}
claude-personal() { set-claude-profile "personal"; claude "$@"; }
claude-work()     { set-claude-profile "work"; claude "$@"; }
EOF

echo "[✓] Configurazione salvata in ~/.zshrc. Esegui 'source ~/.zshrc' per attivare."
