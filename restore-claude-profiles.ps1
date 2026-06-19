<#
.SYNOPSIS
    Script di ripristino e unificazione dei profili (Rimozione Estensione).

.DESCRIPTION
    Questo script esegue il ripristino del sistema se si decide di non usare più 
    l'estensione Claude Profile Switcher. Rileva se la cartella predefinita '.claude' 
    è un collegamento simbolico (symlink) e la rimuove in sicurezza. Successivamente, 
    riporta la cartella fisica '.claude-personal' al nome nativo originale '.claude' 
    ed elimina il profilo '.claude-work' per ripulire il PC.

.REQUISITI
    - Windows PowerShell 5.1 o PowerShell 7+.
    - Diritti di amministratore (gestiti tramite il file .cmd lanciatore).
#>

# ==========================================
# CONFIGURAZIONE PARAMETRIZZATA
# ==========================================
$BaseDir   = $env:USERPROFILE                                   # Percorso della cartella dell'utente corrente (es. C:\Users\nome)
$SuffixP   = "-personal"                                        # Suffisso usato dall'estensione per il profilo personale
$SuffixW   = "-work"                                            # Suffisso usato dall'estensione per il profilo di lavoro
$LogFile   = "$env:USERPROFILE\Desktop\Claude_Migration_Log.txt" # Punta allo stesso file di log per mantenere la cronologia unita

# Definizione dei percorsi delle cartelle coinvolte nel ripristino
$OldDir    = "$BaseDir\.claude"                                 # Percorso standard nativo di Claude (dove l'estensione crea il symlink)
$PersDir   = "$BaseDir\.claude$SuffixP"                         # Cartella fisica del profilo Personale
$WorkDir   = "$BaseDir\.claude$SuffixW"                         # Cartella fisica del profilo Lavoro

# ==========================================
# FUNZIONE DI LOGGING CENTRALIZZATA
# ==========================================
function Write-Log {
    param (
        [string]$Message,                                       # Il testo del messaggio da scrivere
        [System.ConsoleColor]$Color = "White"                   # Il colore del testo nel terminale
    )
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"         # Genera l'orario attuale dell'evento
    Write-Host $Message -ForegroundColor $Color                 # Mostra il messaggio a schermo nel terminale
    "[ $Timestamp ] $Message" | Out-File -FilePath $LogFile -Append -Encoding utf8 # Scrive la riga in modalità append nel log del Desktop
}

# ==========================================
# SCHERMATA INIZIALE E CONFERMA UTENTE
# ==========================================
Clear-Host                                                      # Svuota lo schermo del terminale
Write-Host "=== RIPRISTINO CONFIGURAZIONE ORIGINALE (RIMOZIONE ESTENSIONE) ===" -ForegroundColor Yellow
Write-Host "Questo script rimuovera i collegamenti dell'estensione, ripristinando"
Write-Host "il profilo Personal come cartella principale predefinita di Claude.`n"

# Richiede una conferma esplicita prima di alterare o eliminare cartelle
$Confirmation = Read-Host "Vuoi unificare i profili e tornare alla configurazione nativa? (S/N)"

# Se l'utente non digita S o Y l'operazione viene interrotta istantaneamente
if ($Confirmation -notmatch "^[sS]$" -and $Confirmation -notmatch "^[yY]$") { 
    Write-Log "[i] Operazione di rollback manuale annullata dall'utente." "Yellow"
    Exit 
}

# Apre una nuova sezione dedicata al ripristino all'interno del file di log comune
Write-Log "`n=== INIZIO RIPRISTINO MANUALE (DISINSTALLAZIONE ESTENSIONE) ===" "Cyan"

# ==========================================
# AVVIO OPERAZIONI DI RIPRISTINO E PULIZIA
# ==========================================
try {
    # 1. RIMOZIONE DEL SYMLINK DELL'ESTENSIONE
    if (Test-Path $OldDir) {
        # Recupera le proprietà avanzate della cartella .claude principale
        $Item = Get-Item $OldDir
        
        # Verifica se la cartella è un vero collegamento di tipo Symlink (ReparsePoint)
        if ($Item.Attributes -match "ReparsePoint") {
            # Elimina il collegamento virtuale (l'azione non cancella i file reali dentro i profili)
            Remove-Item -Path $OldDir -Force -ErrorAction Stop
            Write-Log "[✓] Rimosso con successo il collegamento simbolico virtuale creato dall'estensione." "Green"
        } else {
            # Se è una cartella reale, blocca il ripristino per evitare la perdita accidentale di dati importanti
            Write-Log "[!] Attenzione: '$OldDir' e una cartella fisica e non un collegamento. Ripristino interrotto per sicurezza." "Yellow"
            Exit
        }
    }

    # 2. RIPRISTINO DEL PROFILO PERSONALE COME CARTELLA NATIVA
    if (Test-Path $PersDir) {
        # Se il vecchio percorso è stato liberato correttamente dalla rimozione del symlink
        if (!(Test-Path $OldDir)) {
            # Rinomina/Sposta la cartella .claude-personal riportandola al nome standard .claude
            Move-Item -Path $PersDir -Destination $OldDir -Force -ErrorAction Stop
            Write-Log "[✓] Profilo Personal ripristinato come cartella fisica principale (.claude)." "Green"
        } else {
            Write-Log "[X] Errore: Il percorso di destinazione '$OldDir' risulta ancora occupato." "Red"
        }
    } else {
        Write-Log "[i] Cartella '$PersDir' non trovata. Impossibile ripristinare il profilo personale originario." "Gray"
    }

    # 3. ELIMINAZIONE DEL PROFILO WORK
    if (Test-Path $WorkDir) {
        # Elimina in modo definitivo la cartella di lavoro speculare e tutto il suo contenuto
        Remove-Item -Path $WorkDir -Recurse -Force -ErrorAction Stop
        Write-Log "[✓] Cartella profilo Work ($WorkDir) eliminata e rimossa dal sistema." "Green"
    } else {
        Write-Log "[i] Nessuna cartella Work residua da rimuovere." "Gray"
    }

    Write-Log "=== [COMPLETATO] Sistema ripulito e riportato con successo allo stato nativo di Windows. ===" "Green"

} catch {
    # Registra nel log l'errore di sistema che ha bloccato il ripristino (es. cartella bloccata da un programma aperto)
    Write-Log "[ERRORE CRITICO] Si e verificato un problema bloccante durante il ripristino: $_" "Red"
}
