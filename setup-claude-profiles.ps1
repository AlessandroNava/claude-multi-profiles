if (!(Test-Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE -Force | Out-Null }

$ConfigScript = @"

# === CONFIGURAZIONE CLAUDE CODE (LINK SIMBOLICI MULTI-ACCOUNT) ===
function set-claude-profile {
    param ([ValidateSet("personal", "work")][string]`\$Target)
    `$BaseDir = `\$env:USERPROFILE
    
    # Pulizia Link Vecchi
    `$Links = @("\.claude", "\.claude-mem", "\.claude-code-gui", "\.claude.json")
    foreach (`$l in `$Links) { if (Test-Path "`$BaseDir`$l") { Remove-Item "`$BaseDir`$l" -Force } }

    if (`\$Target -eq "personal") {
        New-Item -ItemType Junction -Path "`\$BaseDir\.claude"          -Target "`\$BaseDir\.claude-personal" | Out-Null
        New-Item -ItemType Junction -Path "`\$BaseDir\.claude-mem"      -Target "`\$BaseDir\.claude-mem-personal" | Out-Null
        New-Item -ItemType Junction -Path "`\$BaseDir\.claude-code-gui" -Target "`\$BaseDir\.claude-code-gui-personal" | Out-Null
        New-Item -ItemType SymbolLink -Path "`\$BaseDir\.claude.json"   -Target "`\$BaseDir\.claude-personal.json" | Out-Null
        Write-Host "[⇄] Profilo: PERSONAL (Pro & MCP inclusi)" -ForegroundColor Cyan
    } 
    elseif (`\$Target -eq "work") {
        if (!(Test-Path "`\$BaseDir\.claude-work")) { New-Item -ItemType Directory "`\$BaseDir\.claude-work" | Out-Null }
        if (!(Test-Path "`\$BaseDir\.claude-mem-work")) { New-Item -ItemType Directory "`\$BaseDir\.claude-mem-work" | Out-Null }
        if (!(Test-Path "`\$BaseDir\.claude-code-gui-work")) { New-Item -ItemType Directory "`\$BaseDir\.claude-code-gui-work" | Out-Null }
        if (!(Test-Path "`\$BaseDir\.claude-work.json")) { Out-File -FilePath "`\$BaseDir\.claude-work.json" -InputObject "{}" -Encoding utf8 }

        New-Item -ItemType Junction -Path "`\$BaseDir\.claude"          -Target "`\$BaseDir\.claude-work" | Out-Null
        New-Item -ItemType Junction -Path "`\$BaseDir\.claude-mem"      -Target "`\$BaseDir\.claude-mem-work" | Out-Null
        New-Item -ItemType Junction -Path "`\$BaseDir\.claude-code-gui" -Target "`\$BaseDir\.claude-code-gui-work" | Out-Null
        New-Item -ItemType SymbolLink -Path "`\$BaseDir\.claude.json"   -Target "`\$BaseDir\.claude-work.json" | Out-Null
        Write-Host "[⇄] Profilo: WORK (Team & MCP isolati)" -ForegroundColor Magenta
    }
}
function claude-personal { set-claude-profile "personal"; claude `\$args }
function claude-work     { set-claude-profile "work"; claude `\$args }
# ==================================================================
"@

Add-Content -Path $PROFILE -Value $ConfigScript
. $PROFILE
Write-Host "[✓] Profilo PowerShell aggiornato con i profili Claude!" -ForegroundColor Green
