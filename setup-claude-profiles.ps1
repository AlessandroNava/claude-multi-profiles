# Ottieni o crea il percorso del profilo di PowerShell
if (!(Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

Write-Host "Configurazione profili in $PROFILE..."

# Definisce le funzioni da iniettare nel profilo di PowerShell
$functionsToAdd = @"

function claude-personal {
    `$env:CLAUDE_CONFIG_DIR = "`$HOME\.claude-personal"
    claude `$args
}

function claude-work {
    `$env:CLAUDE_CONFIG_DIR = "`$HOME\.claude-work"
    claude `$args
}
"@

# Rimuove vecchie configurazioni se presenti per non sporcare il file
$profileContent = Get-Content $PROFILE -ErrorAction SilentlyContinue
$cleanContent = $profileContent | Where-Object { $_ -notmatch "claude-personal" -and $_ -notmatch "claude-work" }
$cleanContent | Set-Content $PROFILE

# Aggiunge le nuove funzioni
Add-Content -Path $PROFILE -Value $functionsToAdd

Write-Host "🎉 Setup completato! Riavvia PowerShell per applicare le modifiche." -ForegroundColor Green
