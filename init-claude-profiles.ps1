<#
.SYNOPSIS
    Script di migrazione e sdoppiamento dei profili Claude (Personal & Work).

.DESCRIPTION
    Questo script automatizza lo spostamento delle cartelle e dei file di configurazione
    di Claude dal profilo predefinito a un nuovo profilo "Personal". Successivamente, 
    crea un profilo "Work" pre-popolandolo con comandi, skill e file markdown utili.
    Include la chiusura automatica dei processi bloccanti, un sistema di sicurezza 
    (Rollback) in caso di errore, una conferma iniziale e genera un file di log.

.REQUISITI
    - Windows PowerShell 5.1 o PowerShell 7+.
    - Diritti di lettura/scrittura nella cartella utente ($env:USERPROFILE).

.COME USARLO / ISTRUZIONI:
    1. Configurazione Suffissi: Se desideri nomi diversi per i profili, modifica le variabili 
       $SuffixP e $SuffixW nella sezione "CONFIGURAZIONE PARAMETRIZZATA".
    2. Esecuzione: 
       - Apri PowerShell nella cartella in cui si trova il file.
       - Sblocca l'esecuzione se necessario con: Set-ExecutionPolicy Unrestricted -Scope Process
       - Esegui lo script digitando: .\init-claude-profiles.ps1
    3. Processi attivi: Lo script chiuderà automaticamente Claude Desktop e Claude Code se aperti.
    4. Verifica: Al termine, troverai un file chiamato "Claude_Migration_Log.txt" sul tuo Desktop
       con il dettaglio di tutte le operazioni eseguite.

.LOGICA DI SICUREZZA (ROLLBACK):
    Se lo script fallisce a metà (es. file bloccato o errore di rete), la sezione 'catch'
    interviene immediatamente, annulla le modifiche fatte fino a quel momento ripristinando
    i file originali e scrive l'errore nel file di log.
#>

# ==========================================
# CONFIGURAZIONE PARAMETRIZZATA
# ==========================================
$BaseDir   = $env:USERPROFILE
$SuffixOld = ""                 # Vuoto = profilo standard di partenza
$SuffixP   = "-personal"        # Suffisso per il profilo Personale
$SuffixW   = "-work"            # Suffisso per il profilo Aziendale/Lavoro
$LogFile   = "$env:USERPROFILE\Desktop\Claude_Migration_Log.txt"

# Processi noti da terminare per evitare file bloccati (Claude Desktop e istanze Node/Claude Code)
$TargetProcesses = @("Claude", "claude-code")

# Elenco delle risorse da migrare
$Resources = @(
    @{ Name = "Claude Core";     Old = "$BaseDir\.claude$SuffixOld";     New = "$BaseDir\.claude$SuffixP" },
    @{ Name = "Claude Memory";   Old = "$BaseDir\.claude-mem$SuffixOld"; New = "$BaseDir\.claude-mem$SuffixP" },
    @{ Name = "Claude Code GUI"; Old = "$BaseDir\.claude-code-gui$SuffixOld"; New = "$BaseDir\.claude-code-gui$SuffixP" },
    @{ Name = "File MCP JSON";   Old = "$BaseDir\.claude$SuffixOld.json"; New = "$BaseDir\.claude$SuffixP.json" }
)

$WorkDir    = "$BaseDir\.claude$SuffixW"
$PersDir    = "$BaseDir\.claude$SuffixP"
$MovedItems = @() # Registro interno per gestione rollback

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
Write-Host "=== INIZIALIZZAZIONE PROFILI CLAUDE ===" -ForegroundColor Cyan
Write-Host "Questo script migrerà i file di Claude esistenti nel profilo Personal ($SuffixP)"
Write-Host "e configurerà una nuova cartella pulita per il profilo Work ($SuffixW).`n"

$Confirmation = Read-Host "Vuoi procedere con la migrazione dei profili? (S/N)"

if ($Confirmation -notmatch "^[sS]$" -and $Confirmation -notmatch "^[yY]$") {
    # Se l'utente preme N o qualsiasi altro tasto, interrompe l'esecuzione senza creare il log
    Write-Host "[i] Operazione di migrazione annullata dall'utente." -ForegroundColor Yellow
    Exit
}

# Inizializzazione File di Log dopo la conferma
$InitMsg = "=== INIZIO MIGRAZIONE PROFILI CLAUDE ==="
$InitMsg | Out-File -FilePath $LogFile -Encoding utf8
Write-Log "Inizio procedura automatizzata per i profili Claude..." "Cyan"
Write-Log "File di log configurato in: $LogFile" "DarkGray"

# ==========================================
# CHIUSURA AUTOMATICA PROCESSI ATTIVI
# ==========================================
Write-Log "Verifica dei processi attivi in corso..." "Cyan"
foreach ($ProcName in $TargetProcesses) {
    $ActiveProcs = Get-Process -Name $ProcName -ErrorAction SilentlyContinue
    if ($ActiveProcs) {
        Write-Log "[!] Trovato processo attivo '$ProcName'. Tentativo di terminazione..." "Yellow"
        try {
            Stop-Process -Name $ProcName -Force -ErrorAction Stop
            # Breve pausa per dare il tempo al sistema operativo di rilasciare i file
            Start-Sleep -Seconds 2
            Write-Log "[✓] Processo '$ProcName' terminato correttamente." "Green"
        } catch {
            Write-Log "[X] Impossibile terminare il processo '$ProcName': $_" "Red"
        }
    }
}

# ==========================================
# BLOCCO DI MIGRAZIONE (CON GESTIONE ERRORI)
# ==========================================
try {
    foreach ($Resource in $Resources) {
        if (Test-Path $Resource.Old) {
            if (!(Test-Path $Resource.New)) {
                # Spostamento fisico della risorsa
                Move-Item -Path $Resource.Old -Destination $Resource.New -Force -ErrorAction Stop
                
                # Registra l'azione per un eventuale rollback futuro
                $MovedItems += [PSCustomObject]@{ Old = $Resource.Old; New = $Resource.New }
                Write-Log "[✓] $($Resource.Name) migrata con successo (da $($Resource.Old) a $($Resource.New))." "Green"
            } else {
                Write-Log "[!] Spostamento annullato: '$($Resource.New)' esiste già." "Yellow"
            }
        } else {
            Write-Log "[i] Risorsa originale non trouvata, salto: $($Resource.Old)" "Gray"
        }
    }

    # ==========================================
    # PRE-POPOLAMENTO PROFILO WORK
    # ==========================================
    if (Test-Path $PersDir) {
        if (!(Test-Path $WorkDir)) {
            New-Item -ItemType Directory -Path $WorkDir -Force -ErrorAction Stop | Out-Null
            Write-Log "[✓] Creata cartella profilo Work: $WorkDir" "Green"
        }
        
        foreach ($item in "commands", "skills", "CLAUDE.md") {
            $SourceItem = "$PersDir\$item"
            $DestItem   = "$WorkDir\$item"
            
            if (Test-Path $SourceItem) {
                if (!(Test-Path $DestItem)) {
                    Copy-Item -Path $SourceItem -Destination $DestItem -Recurse -Force -ErrorAction Stop
                    Write-Log "[➔] Copiato elemento '$item' nel profilo aziendale ($SuffixW)." "Magenta"
                } else {
                    Write-Log "[i] Elemento '$item' già presente nel profilo aziendale, copia saltata." "Gray"
                }
            }
        }
    }
    
    Write-Log "`n=== [COMPLETATO] Migrazione eseguita con successo senza errori. ===" "Green"

} catch {
    # ==========================================
    # GESTIONE ROLLBACK IN CASO DI ERRORE
    # ==========================================
    Write-Log "`n[ERRORE CRITICO] Si è verificato un problema durante lo spostamento: $_" "Red"
    Write-Log "[ROLLBACK] Avvio ripristino dello stato iniziale dei file..." "Yellow"
    
    # Esegue il ciclo al contrario per rimettere i file a posto nell'ordine corretto
    for ($i = $MovedItems.Count - 1; $i -ge 0; $i--) {
        $Item = $MovedItems[$i]
        if (Test-Path $Item.New) {
            Move-Item -Path $Item.New -Destination $Item.Old -Force
            Write-Log "[R] Ripristinato file/cartella originale: $($Item.Old)" "Yellow"
        }
    }
    
    Write-Log "=== [ROLLBACK COMPLETATO] Nessuna modifica applicata al sistema. ===" "Orange"
}
