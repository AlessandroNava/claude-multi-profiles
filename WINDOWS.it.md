# Configurazione Multi-Account Claude Code su Windows 11

Questa guida contiene gli script PowerShell necessari per configurare lo switch dei profili su Windows.

---

## 🛠️ Come Eseguire gli Script PowerShell (.ps1)

Per impostazione predefinita, Windows 11 blocca l'esecuzione di script non verificati per motivi di sicurezza. Segui questi passaggi per eseguire i file di automazione senza errori:

1. Chiudi completamente **VS Code**.
2. Apri **PowerShell** e spostati nella cartella in cui si trovano i file usando il comando `cd` (ad esempio se li hai scaricati nella cartella Download):
   ```powershell
   cd \$HOME\Downloads
   ```
3. Sblocca temporaneamente l'esecuzione degli script *solo per la sessione corrente del terminale* lanciando questo comando:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
   ```
4. Esegui lo script di inizializzazione digitando il nome del file preceduto da `.\`:
   ```powershell
   .\init-claude-personal.ps1
   ```
5. Successivamente, esegui il secondo script per configurare i comandi permanenti:
   ```powershell
   .\setup-claude-profiles.ps1
   ```
6. Riavvia il terminale per rendere effettive le modifiche.

---

## 1. Passo 1: Inizializzazione e Migrazione
*   **Nome File:** `init-claude-personal.ps1`
*   **Istruzioni:** Chiudi **VS Code**. Apri PowerShell nella cartella in cui hai salvato il file ed eseguilo. Se Windows blocca l'esecuzione, lancia prima il comando: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process`.

```powershell
\(BaseDir =\)env:USERPROFILE

\$Folders = @(
    @{ Name = "Claude Core";     Old = "\(BaseDir\.claude";          New = "\)BaseDir\.claude-personal" },
    @{ Name = "Claude Memory";   Old = "\(BaseDir\.claude-mem";      New = "\)BaseDir\.claude-mem-personal" },
    @{ Name = "Claude Code GUI"; Old = "\(BaseDir\.claude-code-gui"; New = "\)BaseDir\.claude-code-gui-personal" }
)

Write-Host "Inizio migrazione delle cartelle Claude per il profilo PERSONAL...`n" -ForegroundColor Cyan

# Rinomina cartelle reali
foreach ($Folder in $Folders) {
    if (Test-Path $Folder.Old) {
        if (!(Test-Path $Folder.New)) {
            Rename-Item -Path $Folder.Old -NewName (Split-Path $Folder.New -Leaf) -Force
            Write-Host "[✓] $($Folder.Name) migrata con successo." -ForegroundColor Green
        } else {
            Write-Host "[!] La cartella '$($Folder.New)' esiste già. Rinomina saltata." -ForegroundColor Yellow
        }
    }
}

# Rinomina del file di configurazione MCP globale
if (Test-Path "$BaseDir\.claude.json") {
    if (!(Test-Path "$BaseDir\.claude-personal.json")) {
        Rename-Item -Path "$BaseDir\.claude.json" -NewName ".claude-personal.json" -Force
        Write-Host "[✓] File MCP .claude.json migrato in .claude-personal.json" -ForegroundColor Green
    }
}

# Pre-popolamento ambiente Work: copia comandi, skill e regole globali dal Pro
$WorkDir = "$BaseDir\.claude-work"
$PersDir = "$BaseDir\.claude-personal"
if (Test-Path $PersDir) {
    New-Item -ItemType Directory -Path $WorkDir -Force | Out-Null
    foreach ($item in "commands", "skills", "CLAUDE.md") {
        if (Test-Path "$PersDir\$item") {
            Copy-Item -Path "$PersDir\$item" -Destination "$WorkDir\$item" -Recurse -Force
            Write-Host "[➔] Copiato elemento '$item' nel profilo aziendale per uniformità." -ForegroundColor Magenta
        }
    }
}

Write-Host "`n[COMPLETATO] Configurazione fisica pronta. Esegui ora il setup del profilo." -ForegroundColor Green
```

---

## 2. Passo 2: Configurazione dei Profili nel Terminale
*   **Nome File:** `setup-claude-profiles.ps1`
*   **Istruzioni:** Esegui questo file in PowerShell. Inserirà in modo permanente i comandi di switch nel tuo profilo utente globale di Windows (`$PROFILE`).

```powershell
if (!(Test-Path \(PROFILE)) { New-Item -ItemType File -Path\)PROFILE -Force | Out-Null }

\$ConfigScript = @'

# === CONFIGURAZIONE CLAUDE CODE (LINK SIMBOLICI MULTI-ACCOUNT) ===
function set-claude-profile {
    param ([ValidateSet("personal", "work")][string]\$Target)
    \(BaseDir =\)env:USERPROFILE
    
    # Pulizia Link Simbolici precedenti (non tocca i dati reali)
    \$Links = @("\.claude", "\.claude-mem", "\.claude-code-gui", "\.claude.json")
    foreach (\(l in\)Links) { if (Test-Path "\(BaseDir\)l") { Remove-Item "\(BaseDir\)l" -Force } }

    if (\$Target -eq "personal") {
        New-Item -ItemType Junction -Path "\(BaseDir\.claude"          -Target "\)BaseDir\.claude-personal" | Out-Null
        New-Item -ItemType Junction -Path "\(BaseDir\.claude-mem"      -Target "\)BaseDir\.claude-mem-personal" | Out-Null
        New-Item -ItemType Junction -Path "\(BaseDir\.claude-code-gui" -Target "\)BaseDir\.claude-code-gui-personal" | Out-Null
        New-Item -ItemType SymbolLink -Path "\(BaseDir\.claude.json"   -Target "\)BaseDir\.claude-personal.json" | Out-Null
        Write-Host "[⇄] Profilo attivo: PERSONAL (Pro & MCP caricati)" -ForegroundColor Cyan
    } 
    elseif (\$Target -eq "work") {
        if (!(Test-Path "\(BaseDir\.claude-work")) { New-Item -ItemType Directory "\)BaseDir\.claude-work" | Out-Null }
        if (!(Test-Path "\(BaseDir\.claude-mem-work")) { New-Item -ItemType Directory "\)BaseDir\.claude-mem-work" | Out-Null }
        if (!(Test-Path "\(BaseDir\.claude-code-gui-work")) { New-Item -ItemType Directory "\)BaseDir\.claude-code-gui-work" | Out-Null }
        if (!(Test-Path "\(BaseDir\.claude-work.json")) { Out-File -FilePath "\)BaseDir\.claude-work.json" -InputObject "{}" -Encoding utf8 }

        New-Item -ItemType Junction -Path "\(BaseDir\.claude"          -Target "\)BaseDir\.claude-work" | Out-Null
        New-Item -ItemType Junction -Path "\(BaseDir\.claude-mem"      -Target "\)BaseDir\.claude-mem-work" | Out-Null
        New-Item -ItemType Junction -Path "\(BaseDir\.claude-code-gui" -Target "\)BaseDir\.claude-code-gui-work" | Out-Null
        New-Item -ItemType SymbolLink -Path "\(BaseDir\.claude.json"   -Target "\)BaseDir\.claude-work.json" | Out-Null
        Write-Host "[⇄] Profilo attivo: WORK (Team & MCP isolati)" -ForegroundColor Magenta
    }
}
function claude-personal { set-claude-profile "personal"; claude \$args }
function claude-work     { set-claude-profile "work"; claude \$args }
# ==================================================================
'@

Add-Content -Path \(PROFILE -Value\)ConfigScript
. \$PROFILE
Write-Host "[✓] Profilo PowerShell configurato! Riavvia il terminale per applicare." -ForegroundColor Green
```
