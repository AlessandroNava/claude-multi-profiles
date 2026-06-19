@echo off
title Spostamento verso Profilo WORK (Aziendale)

:: Salva il percorso della cartella corrente prima dell'elevazione UAC
set "SCRIPT_DIR=%~dp0"

:: Verifica i privilegi di amministratore e li richiede se mancanti
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process -FilePath '%0' -Verb RunAs"
    exit /b
)

cd /d "%SCRIPT_DIR%"

echo [1/3] Salvataggio contesto corrente (Profilo PERSONAL)...
:: Esegue Claude Code nel profilo personale per generare il file HANDOFF.md prima di chiudere
call claude -c "Usa la skill handoff per salvare la sessione del profilo personale prima dello switch"

echo [2/3] Chiusura forzata dei processi Claude...
powershell -NoProfile -Command "Stop-Process -Name 'Claude', 'claude-code' -Force -ErrorAction SilentlyContinue"
timeout /t 2 /nobreak >nul

echo [3/3] Configurazione e switch verso le cartelle del profilo WORK...
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%init-claude-profiles.ps1"

echo ======================================================
echo [✓] Passaggio a profilo WORK completato con successo!
echo     Nel nuovo profilo, digita: "leggi HANDOFF.md"
echo ======================================================
pause