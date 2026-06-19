<#
.SYNOPSIS
    Script di inizializzazione profili compatibile con Claude Profile Switcher.
.DESCRIPTION
    Versione con auto-installazione nativa della skill handoff integrata.
.VERSIONE
    4.0
#>

$BaseDir   = $env:USERPROFILE
$SuffixP   = "-personal"
$SuffixW   = "-work"
$LogFile   = "$env:USERPROFILE\Desktop\Claude_Migration_Log.txt"

$PersDir   = "$BaseDir\.claude$SuffixP"
$WorkDir   = "$BaseDir\.claude$SuffixW"

# Percorso fisico dove risiede la skill nel profilo personale
$HandoffFolder = "$PersDir\skills\handoff"
$HandoffFile   = "$HandoffFolder\SKILL.md"

$TargetProcesses = @("Claude", "claude-code")

function Write-Log {
    param (
        [string]$Message,
        [System.ConsoleColor]$Color = "White"
    )
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host $Message -ForegroundColor $Color
    "[ $Timestamp ] $Message" | Out-File -FilePath $LogFile -Append -Encoding utf8
}

Clear-Host
Write-Host "=== CONFIGURAZIONE PROFILI CLAUDE ===" -ForegroundColor Cyan

$Confirmation = Read-Host "Vuoi procedere? (S/N)"
if ($Confirmation -notmatch "^[sS]$" -and $Confirmation -notmatch "^[yY]$") { 
    Write-Host "Operazione annullata." -ForegroundColor Yellow
    Exit
}

"=== INIZIO CONFIGURAZIONE ===" | Out-File -FilePath $LogFile -Encoding utf8

foreach ($ProcName in $TargetProcesses) {
    $ActiveProcs = Get-Process -Name $ProcName -ErrorAction SilentlyContinue
    if ($ActiveProcs) {
        Write-Log "Chiusura processo: $ProcName" "Yellow"
        Stop-Process -Name $ProcName -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    }
}

if (!(Test-Path $PersDir)) {
    New-Item -ItemType Directory -Path $PersDir -Force -ErrorAction SilentlyContinue | Out-Null
    Write-Log "[OK] Cartella Personale creata" "Green"
} else {
    Write-Log "[INFO] Cartella Personale gia esistente." "Gray"
}

if (!(Test-Path $WorkDir)) {
    New-Item -ItemType Directory -Path $WorkDir -Force -ErrorAction SilentlyContinue | Out-Null
    Write-Log "[OK] Cartella Work creata" "Green"
} else {
    Write-Log "[INFO] Cartella Work gia esistente." "Gray"
}

# ==========================================
# 4. CONTROLLO E AUTO-INSTALLAZIONE SKILL HANDOFF
# ==========================================
if (!(Test-Path $HandoffFile)) {
    Write-Log "[i] Skill handoff assente. Installazione automatica in corso..." "Yellow"
    
    # Crea la struttura delle cartelle se mancante
    New-Item -ItemType Directory -Path $HandoffFolder -Force -ErrorAction SilentlyContinue | Out-Null
    
    # Definisce il codice della skill tramite un array di stringhe pulite (evita problemi di escape)
    $Lines = @(
        "---",
        "name: handoff",
        "description: Use this skill when the user asks to save, pause, or transfer the current chat session context to another profile or agent.",
        "---",
        "",
        "# Session Handoff Skill",
        "",
        "When this skill is triggered, you must help the user transition their current workspace state to a new session by creating a summary file.",
        "",
        "## Instructions",
        "1. Scan the recent chat history, active branch, and modified files in the repository.",
        "2. Generate a compact status update containing:",
        "   - **Current Goal**: What task is currently in progress.",
        "   - **Accomplished**: What has already been coded or completed.",
        "   - **Next Steps**: Explicit checklist of what the next profile needs to do.",
        "   - **Continuation Prompt**: A copy-pasteable paragraph that summarizes everything for the next session.",
        "3. Save this summary as 'HANDOFF.md' in the project root folder.",
        "4. Output the continuation prompt clearly in the chat response."
    )
    
    # Genera fisicamente il file SKILL.md nativo con la codifica corretta
    $Lines | Out-File -FilePath $HandoffFile -Encoding utf8 -Force
    Write-Log "[✓] Skill handoff installata con successo nel profilo Personal." "Green"
}

# ==========================================
# 5. COPIA DELLE SKILL DAL PROFILO PERSONAL A WORK
# ==========================================
$ItemsToCopy = @("commands", "skills", "CLAUDE.md")
foreach ($item in $ItemsToCopy) {
    $SourceItem = "$PersDir\$item"
    $DestItem   = "$WorkDir\$item"
    if ((Test-Path $SourceItem) -and (!(Test-Path $DestItem))) {
        Copy-Item -Path $SourceItem -Destination $DestItem -Recurse -Force -ErrorAction SilentlyContinue
        Write-Log "[OK] Copiato elemento nel profilo Work: $item" "Magenta"
    }
}

Write-Log "=== OPERAZIONE COMPLETATA ===" "Green"