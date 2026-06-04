# Claude Code Multi-Account Setup for Windows 11

This guide provides the necessary PowerShell scripts to configure multi-profile environment isolation on Windows 11 using directory junctions.

---

## 🛠️ How to Run PowerShell Scripts (.ps1)

By default, Windows 11 restricts execution of unverified scripts for security reasons. Follow these steps to run the automation files successfully:

1. Close **VS Code** completely.
2. Open **PowerShell** and navigate to the directory where your `.ps1` files are stored using the `cd` command (e.g., if they are in your Downloads folder):
   ```powershell
   cd \$HOME\Downloads
   ```
3. Temporarily unblock script execution for your current terminal session by running:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
   ```
4. Execute the initialization script by typing its name preceded by `.\`:
   ```powershell
   .\init-claude-personal.ps1
   ```
5. Next, execute the profile manager setup script:
   ```powershell
   .\setup-claude-profiles.ps1
   ```
6. Restart your terminal to apply the changes.

---

## 1. Step 1: Initialization and Data Migration
*   **Filename:** `init-claude-personal.ps1`
*   **Instructions:** Close **VS Code** completely. Open PowerShell in the directory where you saved this file and run it. 

*Note: If Windows blocks script execution, run this command first in your terminal: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process`.*

```powershell
\(BaseDir =\)env:USERPROFILE

# List of folders to migrate
\$Folders = @(
    @{ Name = "Claude Core";     Old = "\(BaseDir\.claude";          New = "\)BaseDir\.claude-personal" },
    @{ Name = "Claude Memory";   Old = "\(BaseDir\.claude-mem";      New = "\)BaseDir\.claude-mem-personal" },
    @{ Name = "Claude Code GUI"; Old = "\(BaseDir\.claude-code-gui"; New = "\)BaseDir\.claude-code-gui-personal" }
)

Write-Host "Starting Claude folder migration for the PERSONAL profile...`n" -ForegroundColor Cyan

# Rename physical folders safely
foreach ($Folder in $Folders) {
    if (Test-Path $Folder.Old) {
        if (!(Test-Path $Folder.New)) {
            Rename-Item -Path $Folder.Old -NewName (Split-Path $Folder.New -Leaf) -Force
            Write-Host "[✓] $($Folder.Name) migrated successfully." -ForegroundColor Green
        } else {
            Write-Host "[!] Target directory '$($Folder.New)' already exists. Migration skipped." -ForegroundColor Yellow
        }
    }
}

# Migrate global MCP configuration file
if (Test-Path "$BaseDir\.claude.json") {
    if (!(Test-Path "$BaseDir\.claude-personal.json")) {
        Rename-Item -Path "$BaseDir\.claude.json" -NewName ".claude-personal.json" -Force
        Write-Host "[✓] Global MCP file .claude.json migrated to .claude-personal.json" -ForegroundColor Green
    }
}

# Pre-populate Work environment: copy global commands, skills, and rules from Pro for seamless onboarding
$WorkDir = "$BaseDir\.claude-work"
$PersDir = "$BaseDir\.claude-personal"
if (Test-Path $PersDir) {
    New-Item -ItemType Directory -Path $WorkDir -Force | Out-Null
    foreach ($item in "commands", "skills", "CLAUDE.md") {
        if (Test-Path "$PersDir\$item") {
            Copy-Item -Path "$PersDir\$item" -Destination "$WorkDir\$item" -Recurse -Force
            Write-Host "[➔] Copied '$item' to the corporate profile for environment consistency." -ForegroundColor Magenta
        }
    }
}

Write-Host "`n[COMPLETED] Physical folders are ready. You can now run the profile setup script." -ForegroundColor Green
```

---

## 2. Step 2: Terminal Profile Configuration
*   **Filename:** `setup-claude-profiles.ps1`
*   **Instructions:** Run this script in PowerShell. It will permanently append the profile-switching functions and shortcuts into your global Windows PowerShell profile (`$PROFILE`).

```powershell
if (!(Test-Path \(PROFILE)) { New-Item -ItemType File -Path\)PROFILE -Force | Out-Null }

\$ConfigScript = @'

# === CLAUDE CODE MULTI-ACCOUNT CONFIGURATION (JUNCTIONS) ===
function set-claude-profile {
    param ([ValidateSet("personal", "work")][string]\$Target)
    \(BaseDir =\)env:USERPROFILE
    
    # Safely remove previous symbolic links (leaves real physical data intact)
    \$Links = @("\.claude", "\.claude-mem", "\.claude-code-gui", "\.claude.json")
    foreach (\(l in\)Links) { if (Test-Path "\(BaseDir\)l") { Remove-Item "\(BaseDir\)l" -Force } }

    if (\$Target -eq "personal") {
        New-Item -ItemType Junction -Path "\(BaseDir\.claude"          -Target "\)BaseDir\.claude-personal" | Out-Null
        New-Item -ItemType Junction -Path "\(BaseDir\.claude-mem"      -Target "\)BaseDir\.claude-mem-personal" | Out-Null
        New-Item -ItemType Junction -Path "\(BaseDir\.claude-code-gui" -Target "\)BaseDir\.claude-code-gui-personal" | Out-Null
        New-Item -ItemType SymbolLink -Path "\(BaseDir\.claude.json"   -Target "\)BaseDir\.claude-personal.json" | Out-Null
        Write-Host "[⇄] Active Profile: PERSONAL (Pro & MCP loaded)" -ForegroundColor Cyan
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
        Write-Host "[⇄] Active Profile: WORK (Team & MCP sandboxed)" -ForegroundColor Magenta
    }
}
function claude-personal { set-claude-profile "personal"; claude \$args }
function claude-work     { set-claude-profile "work"; claude \$args }
# ==================================================================
'@

Add-Content -Path \(PROFILE -Value\)ConfigScript
. \$PROFILE
Write-Host "[✓] PowerShell profile successfully updated with Claude environments!" -ForegroundColor Green
```
