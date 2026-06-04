# claude-multi-profiles

[![Platform](https://shields.io)](./)
[![Language](https://shields.io)](./README.it.md)
[![License: MIT](https://shields.io)](https://opensource.org)

> Script e documentazione per gestire e scambiare facilmente account multipli (Personal/Pro e Team/Work) in Claude Code su Windows, macOS e Linux.

🇬🇧 **Note for English users:** The main documentation is available in English in the [README.md](./README.md) file.

---

## 📐 1. Logica di Funzionamento (Architettura)

L'estensione grafica di VS Code e la CLI ufficiale di Claude Code puntano in modo rigido ad alcune directory fisse nella cartella dell'utente (`~` o `%USERPROFILE%`). Se si effettua il login con l'account Team, i token e la cronologia dell'account Pro vengono sovrascritti.

Questo sistema risolve il problema alla radice **sostituendo le cartelle e i file reali con dei Link Simbolici (Symlink/Junctions)**. 

### Struttura delle Directory sul PC

*   **Ambiente Fisico Reale (Isolato):**
    *   `.claude-personal` / `.claude-work` → Token di sessione, cache degli agenti, comandi globali.
    *   `.claude-mem-personal` / `.claude-mem-work` → Memoria a lungo termine (*Auto-memory*).
    *   `.claude-code-gui-personal` / `.claude-code-gui-work` → Cache dell'interfaccia grafica di VS Code.
    *   `.claude-personal.json` / `.claude-work.json` → Configurazioni e server dei protocolli **MCP** globali.
*   **Ambiente Logico (I link simbolici attivi letti da VS Code e dalla CLI):**
    *   `.claude` → *(punta a personal O work)*
    *   `.claude-mem` → *(punta a personal O work)*
    *   `.claude-code-gui` → *(punta a personal O work)*
    *   `.claude.json` → *(punta a personal O work)*

Quando si esegue il comando di switch, i link simbolici vengono scambiati all'istante. **Sia il terminale sia l'estensione grafica di VS Code seguiranno istantaneamente l'account attivato.**

---

## 🚀 2. Flusso di Lavoro Quotidiano

Dopo aver completato l'installazione, **evita di digitare il comando nativo `claude` da solo**. Utilizza sempre i comandi veloci dedicati che si occupano di verificare e scambiare il profilo prima di avviare Claude:

### 👤 Scenario A: Progetti Personali / Sviluppo Privato (Pro)
Apri il terminale e digita:
```bash
claude-personal
```
*   **Cosa accade:** I link si collegano alle cartelle `-personal`. VS Code (interfaccia grafica ed estensione) e la riga di comando ereditano istantaneamente i tuoi vecchi login, le memorie memorizzate nel tempo e le configurazioni MCP private.

### 🏢 Scenario B: Progetti Aziendali / Codice Clienti (Team)
Apri il terminale e digita:
```bash
claude-work
```
*   **Cosa accade:** I link puntano a `.claude-work`. 
*   **Solo al primo avvio assoluto:** Claude Code rileverà una nuova installazione vuota. L'interfaccia o il terminale apriranno il browser chiedendo il login. Inserisci le tue credenziali **Team/Enterprise aziendali**.
*   **Dal secondo avvio:** Sarai subito operativo. Tutta la cronologia aziendale e i server MCP del lavoro saranno blindati e separati dall'account privato.

---

## 🛠️ 3. Guide di Installazione Specifiche

Seleziona la guida dettagliata contenente gli script di inizializzazione e configurazione in base al tuo sistema operativo:

*   👉 **[WINDOWS.md](./WINDOWS.md)** / **[WINDOWS.it.md](./WINDOWS.it.md)**: Istruzioni e script per Windows 11 (PowerShell).
*   👉 **[UNIX.md](./UNIX.md)** / **[UNIX.it.md](./UNIX.it.md)**: Istruzioni e script per macOS e Linux (Zsh/Bash).

---

## ⚠️ 4. Risoluzione Problemi (Troubleshooting)

*   **Errore "Accesso Negato / File Bloccato" in fase di migrazione:**
    Assicurati che **VS Code** sia completamente chiuso e che non ci siano processi `claude` attivi in background nel Task Manager (Gestione Attività).
*   **I link simbolici non cambiano o l'estensione grafica mostra l'account sbagliato:**
    Se avevi VS Code aperto mentre hai lanciato il comando di switch, l'IDE potrebbe aver mantenuto in cache la vecchia sessione. Chiudi e riapri la finestra di VS Code per forzare la rilettura dei link simbolici modificati.
*   **Errore "Impossibile creare un file già esistente" (Windows):**
    Significa che lo script ha trovato una cartella reale bloccata dove dovrebbe risiedere un link simbolico. Cancella manualmente la cartella vuota `.claude` incriminata nella tua directory utente (dopo aver verificato che i dati importanti siano al sicuro dentro `.claude-personal` o `.claude-work`) e riesegui il comando di switch.

---

## 📄 Licenza

Questo progetto è rilasciato sotto licenza MIT. Consulta il file [LICENSE](LICENSE) per ulteriori dettagli.
