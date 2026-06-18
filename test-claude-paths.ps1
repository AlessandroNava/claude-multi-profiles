<#
.SYNOPSIS
    Script di diagnostica preliminare per i percorsi di Claude.
.DESCRIPTION
    Verifica l'esistenza dei file e delle cartelle di origine prima di 
    eseguire la migrazione definitiva, mostrando lo stato a schermo.
#>

$BaseDir = $env:USERPROFILE
Write-Host "=== VERIFICA PRELIMINARE DEI PERCORSI CLAUDE ===" -ForegroundColor Cyan
Write-Host "Cartella Utente rilevata: $BaseDir`n" -ForegroundColor DarkGray

# Elenco dei percorsi critici da controllare
$PathsToCheck = @(
    @{ Name = "Cartella Claude Core"     ; Path = "$BaseDir\.claude" }
    @{ Name = "Cartella Claude Memory"   ; Path = "$BaseDir\.claude-mem" }
    @{ Name = "Cartella Claude Code GUI" ; Path = "$BaseDir\.claude-code-gui" }
    @{ Name = "File Configurazione JSON" ; Path = "$BaseDir\.claude.json" }
)

$FoundCount = 0

foreach ($Target in $PathsToCheck) {
    if (Test-Path $Target.Path) {
        Write-Host "[TROVATO]  " -ForegroundColor Green -NoNewline
        Write-Host "$($Target.Name): " -NoNewline
        Write-Host $Target.Path -ForegroundColor Gray
        $FoundCount++
    } else {
        Write-Host "[ASSENTE]  " -ForegroundColor Yellow -NoNewline
        Write-Host "$($Target.Name): " -NoNewline
        Write-Host $Target.Path -ForegroundColor DarkGray
    }
}

Write-Host "`n=== RIEPILOGO STATO ===" -ForegroundColor Cyan
if ($FoundCount -eq 0) {
    Write-Host "[!] Nessuna risorsa originale trovata. Claude potrebbe non essere ancora stato configurato su questo PC." -ForegroundColor Yellow
} else {
    Write-Host "[✓] Trovate $FoundCount risorse su $($PathsToCheck.Count). Puoi procedere con la migrazione in sicurezza." -ForegroundColor Green
}
