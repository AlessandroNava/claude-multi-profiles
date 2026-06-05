# 1. Rimuovi i vecchi collegamenti simbolici
Remove-Item -Path "$HOME\.claude" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$HOME\.claude-mem" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$HOME\.claude-code-gui" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$HOME\.claude.json" -Force -ErrorAction SilentlyContinue

# 2. Trasforma la vecchia cartella personale nel percorso standard nativo
# In questo modo VS Code la leggerà in automatico senza bisogno di variabili
Move-Item -Path "$HOME\.claude-personal" -Destination "$HOME\.claude" -Force
Write-Host "✅ Vecchie configurazioni rimosse con successo!" -ForegroundColor Green
Write-Host "La cartella personale è stata spostata in $HOME\.claude" -ForegroundColor Green