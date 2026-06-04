$BaseDir = $env:USERPROFILE

# Elenco cartelle da migrare
$Folders = @(
    @{ Name = "Claude Core";     Old = "$BaseDir\.claude";          New = "$BaseDir\.claude-personal" },
    @{ Name = "Claude Memory";   Old = "$BaseDir\.claude-mem";      New = "$BaseDir\.claude-mem-personal" },
    @{ Name = "Claude Code GUI"; Old = "$BaseDir\.claude-code-gui"; New = "$BaseDir\.claude-code-gui-personal" }
)

Write-Host "Inizio migrazione delle cartelle Claude per il profilo PERSONAL...`n" -ForegroundColor Cyan

# Migrazione Cartelle
foreach ($Folder in $Folders) {
    if (Test-Path $Folder.Old) {
        if (!(Test-Path $Folder.New)) {
            Rename-Item -Path $Folder.Old -NewName (Split-Path $Folder.New -Leaf) -Force
            Write-Host "[✓] $($Folder.Name) migrata." -ForegroundColor Green
        }
    }
}

# Migrazione del file MCP globale .claude.json
if (Test-Path "$BaseDir\.claude.json") {
    if (!(Test-Path "$BaseDir\.claude-personal.json")) {
        Rename-Item -Path "$BaseDir\.claude.json" -NewName ".claude-personal.json" -Force
        Write-Host "[✓] File MCP .claude.json migrato in .claude-personal.json" -ForegroundColor Green
    }
}

# PRE-POPOLAMENTO WORK: Copia comandi/skills/CLAUDE.md dal personal al work
$WorkDir = "$BaseDir\.claude-work"
$PersDir = "$BaseDir\.claude-personal"
if (Test-Path $PersDir) {
    New-Item -ItemType Directory -Path $WorkDir -Force | Out-Null
    foreach ($item in "commands", "skills", "CLAUDE.md") {
        if (Test-Path "$PersDir\$item") {
            Copy-Item -Path "$PersDir\$item" -Destination "$WorkDir\$item" -Recurse -Force
            Write-Host "[➔] Copiato elemento '$item' nel profilo aziendale per comodità." -ForegroundColor Magenta
        }
    }
}
