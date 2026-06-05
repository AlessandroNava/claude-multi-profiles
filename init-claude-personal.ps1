# Crea le directory isolate nella cartella utente
New-Item -ItemType Directory -Force -Path "$HOME\.claude-personal" | Out-Null
New-Item -ItemType Directory -Force -Path "$HOME\.claude-work" | Out-Null

Write-Host "✅ Cartelle di configurazione isolate create con successo!" -ForegroundColor Green
Write-Host "Personale: $HOME\.claude-personal"
Write-Host "Lavoro:    $HOME\.claude-work"
Write-Host "Ora puoi configurare i tuoi profili separatamente in queste directory." -ForegroundColor Green