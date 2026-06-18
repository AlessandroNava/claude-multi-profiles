@echo off
title Verifica Percorsi Claude
:: Avvia lo script di controllo senza richiedere privilegi amministrativi (non servono per leggere)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0test-claude-paths.ps1"
pause
