<#
.SYNOPSIS
    Script di ripristino per i profili Claude (Rollback Manuale con Conferma).

.DESCRIPTION
    Questo script esegue l'operazione inversa rispetto a init-claude-profiles.ps1.
    Riporta i file dal profilo "-personal" al profilo standard originale e rimuove 
    il profilo "-work" temporaneo. Richiede una conferma interattiva prima di procedere.

.COME USARLO:
    Esegui lo script digitando da PowerShell nella cartella del file: 
    .\restore-claude-profiles.ps1
#>

# ==========================================
# CONFIGURAZIONE PARAMETRIZZATA
# ==========================================
$BaseDir   = $env:USERPROFILE
$SuffixOld = ""                 # Profilo di partenza originale
$SuffixP   = "-personal"        # Profilo da cui recuperare i dati
$SuffixW   = "-work"            # Profilo da eliminare
$LogFile   = "$env:USERPROFILE\Desktop\Claude_Migration_Log.txt"

# Elenco delle risorse da ripristinare
$Resources = @(
    @{ Name = "Claude Core";     Old = "$BaseDir\.claude$SuffixP";     New = "$BaseDir\.claude$SuffixOld" },
    @{ Name = "Claude Memory";   Old = "$BaseDir\.claude-mem$SuffixP"; New = "$BaseDir\.claude-mem$SuffixOld" },
    @{ Name = "Claude Code GUI"; Old = "$BaseDir\.claude-code-gui$SuffixP"; New = "$BaseDir\.claude-code-gui$SuffixOld" },
    @{ Name = "File MCP JSON";   Old = "$BaseDir\.claude$SuffixP.json"; New = "$BaseDir\.claude$SuffixOld.json" }
)

$WorkDir = "$BaseDir\.claude$SuffixW"

# Helper interno per scrivere a schermo e nel file di log contemporaneamente
function Write-Log {
    param (
        [string]$Message,
        [System.ConsoleColor]$Color = "White"
    )
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host $Message -ForegroundColor $Color
    "[ $Timestamp ] $Message" | Out-File -FilePath $LogFile -Append -Encoding utf8
}

# ==========================================
# RICHIESTA DI CONFERMA INTERATTIVA
# ==========================================
Clear-Host
Write-Host "=== ATTENZIONE: RIPRISTINO CONFIGURAZIONE ORIGINALE ===" -ForegroundColor Yellow
Write-Host "Questo script riporterà i profili Claude allo stato iniziale di partenza"
Write-Host "e cancellerà l'attuale profilo Work ($WorkDir).`n"

$Confirmation = Read-Host "Vuoi procedere con il rollback manuale? (S/N)"

if ($Confirmation -notmatch "^[sS]$" -and $Confirmation -notmatch "^[yY]$") {
    # Se l'utente preme N o qualsiasi altro tasto, interrompe l'esecuzione
    Write-Log "[i] Operazione di ripristino annullata dall'utente." "Yellow"
    Exit
}

# Apertura sessione di ripristino nel log dopo la conferma
Write-Log "`n=== INIZIO RIPRISTINO MANUALE (ROLLBACK) ===" "Cyan"

# ==========================================
# AVVIO OPERAZIONI DI RIPRISTINO
# ==========================================
try {
    # 1. Spostamento inverso dei dati da Personal a Profilo Standard
    foreach ($Resource in $Resources) {
        if (Test-Path $Resource.Old) {
            if (!(Test-Path $Resource.New)) {
                Move-Item -Path $Resource.Old -Destination $Resource.New -Force -ErrorAction Stop
                Write-Log "[✓] Ripristinato: $($Resource.Name) allo stato iniziale di partenza." "Green"
            } else {
                Write-Log "[!] Impossibile ripristinare $($Resource.Name): il percorso originale '$($Resource.New)' esiste già." "Yellow"
            }
        } else {
            Write-Log "[i] Profilo personal non trovato per $($Resource.Name), ripristino non necessario." "Gray"
        }
    }

    # 2. Rimozione e pulizia della cartella Work generata in precedenza
    if (Test-Path $WorkDir) {
        Write-Log "[?] Rimozione del profilo Work temporaneo ($WorkDir)..." "Cyan"
        Remove-Item -Path $WorkDir -Recurse -Force -ErrorAction Stop
        Write-Log "[✓] Profilo Work eliminato con successo dal sistema." "Green"
    } else {
        Write-Log "[i] Nessuna cartella Work da rimuovere." "Gray"
    }

    Write-Log "=== [COMPLETATO] Sistema riportato interamente allo stato originario. ===" "Green"

} catch {
    Write-Log "[ERRORE CRITICO] Si è verificato un problema durante il ripristino manuale: $_" "Red"
}
