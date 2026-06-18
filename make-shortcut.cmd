@echo off
title Configurazione Scorciatoie Desktop
set "SCRIPT_DIR=%~dp0"

:: Genera lo script PowerShell temporaneo per creare i collegamenti
echo $WshShell = New-Object -ComObject WScript.Shell > "%temp%\make_shortcuts.ps1"
echo $Desktop = [Environment]::GetFolderPath('Desktop') >> "%temp%\make_shortcuts.ps1"

:: Scorciatoia 1: Migrazione Profili
echo $Shortcut1 = $WshShell.CreateShortcut("$Desktop\Claude - Avvia Migrazione.lnk") >> "%temp%\make_shortcuts.ps1"
echo $Shortcut1.TargetPath = "%SCRIPT_DIR%start-claude-migration.cmd" >> "%temp%\make_shortcuts.ps1"
echo $Shortcut1.WorkingDirectory = "%SCRIPT_DIR%" >> "%temp%\make_shortcuts.ps1"
echo $Shortcut1.IconLocation = "shell32.dll, 146" >> "%temp%\make_shortcuts.ps1"
echo $Shortcut1.Save() >> "%temp%\make_shortcuts.ps1"

:: Scorciatoia 2: Ripristino Profili (Rollback)
echo $Shortcut2 = $WshShell.CreateShortcut("$Desktop\Claude - Annulla e Ripristina.lnk") >> "%temp%\make_shortcuts.ps1"
echo $Shortcut2.TargetPath = "%SCRIPT_DIR%start-claude-restore.cmd" >> "%temp%\make_shortcuts.ps1"
echo $Shortcut2.WorkingDirectory = "%SCRIPT_DIR%" >> "%temp%\make_shortcuts.ps1"
echo $Shortcut2.IconLocation = "shell32.dll, 238" >> "%temp%\make_shortcuts.ps1"
echo $Shortcut2.Save() >> "%temp%\make_shortcuts.ps1"

:: Applica il bit di configurazione per "Esegui come Amministratore"
echo function Set-Admin($lnkPath) { >> "%temp%\make_shortcuts.ps1"
echo     $bytes = [System.IO.File]::ReadAllBytes($lnkPath) >> "%temp%\make_shortcuts.ps1"
echo     $bytes[21] = $bytes[21] -bor 32 >> "%temp%\make_shortcuts.ps1"
echo     [System.IO.File]::WriteAllBytes($lnkPath, $bytes) >> "%temp%\make_shortcuts.ps1"
echo } >> "%temp%\make_shortcuts.ps1"
echo Set-Admin "$Desktop\Claude - Avvia Migrazione.lnk" >> "%temp%\make_shortcuts.ps1"
echo Set-Admin "$Desktop\Claude - Annulla e Ripristina.lnk" >> "%temp%\make_shortcuts.ps1"

:: Esegue lo script PowerShell generato
powershell -NoProfile -ExecutionPolicy Bypass -File "%temp%\make_shortcuts.ps1"

:: Pulisce il file temporaneo
del "%temp%\make_shortcuts.ps1"

echo ======================================================
echo [OK] Scorciatoie aggiornate create sul Desktop!
echo ======================================================
pause
