# 1. Rimuovi i vecchi link simbolici temporanei
rm -f "$HOME/.claude"
rm -f "$HOME/.claude-mem"
rm -f "$HOME/.claude-code-gui"
rm -f "$HOME/.claude.json"

# 2. Trasforma la vecchia cartella personale nel percorso standard nativo
# In questo modo VS Code la leggerà in automatico senza bisogno di variabili
mv "$HOME/.claude-personal" "$HOME/.claude"
echo "✅ Vecchie configurazioni rimosse con successo!"
echo "La cartella personale è stata spostata in $HOME/.claude"
echo "Ora puoi configurare il tuo profilo personale in questa directory."