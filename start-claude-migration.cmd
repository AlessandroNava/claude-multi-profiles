@echo off
title Avvio Migrazione Profili Claude

:: Salva il percorso della cartella corrente prima dell'elevazione UAC
set "SCRIPT_DIR=%~dp0"

:: Verifica i privilegi di amministratore e li richiede se mancanti
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Richiesta privilegi di amministratore in corso...
    powershell -Command "Start-Process -FilePath '%0' -Verb RunAs"
    exit /b
)

:: Forza Windows a tornare nella cartella corretta dopo l'elevazione
cd /d "%SCRIPT_DIR%"

:: Avvia lo script PowerShell usando il percorso assoluto salvato in precedenza
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%init-claude-profiles.ps1"
pause
