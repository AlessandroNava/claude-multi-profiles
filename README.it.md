# claude-multi-profiles

Script e documentazione per passare istantaneamente tra più account Claude Code (Personal/Pro e Team/Lavoro) su Windows, macOS e Linux senza conflitti di token o perdite di sessione.

---

## 📐 1. Come Funziona

Di default, la CLI ufficiale di Claude Code e l'estensione grafica di VS Code cercano cartelle fisse all'interno della tua directory utente per salvare i token di sessione, la cronologia e i server MCP.

Invece di utilizzare instabili collegamenti simbolici (Symlink) che corrompono il Portachiavi del Sistema Operativo (OS Keychain) causando disconnessioni continue, questo progetto sfrutta la variabile d'ambiente nativa **`CLAUDE_CONFIG_DIR`**.

### Architettura
- **Profilo Personale / Pro (Default):** Condivide la cartella nativa `~/.claude`. Questo permette **sia al terminale che all'estensione grafica di VS Code** di condividere nativamente il tuo login Pro personale, le memorie e la cronologia privata.
- **Profilo di Lavoro / Team (Isolato):** Viene deviato su una directory isolata (`~/.claude-work`). Isola completamente i tuoi token aziendali, i log delle chat dei clienti e i server MCP di lavoro all'interno del terminale.

---

## 🚀 2. Flusso di Lavoro Giornaliero

Una volta configurato, usa le funzioni dedicate nei tuoi terminali in base al contesto del progetto attuale:

### 👤 Scenario A: Progetti Personali / Sviluppo Privato (Pro)
Apri il tuo terminale e digita:
```bash
claude-personal
```
- **Cosa succede:** La variabile d'ambiente viene azzerata, ripristinando il comportamento standard. **Sia il terminale che il pannello dell'estensione grafica di VS Code** punteranno all'istante al tuo login personale Pro e alla tua cronologia privata.

### 🏢 Scenario B: Progetti Aziendali / Codice Clienti (Team)
Apri il tuo terminale e digita:
```bash
claude-work
```
- **Cosa succede:** La CLI devia la cartella di configurazione su `~/.claude-work`. I tuoi token aziendali e le sessioni del team rimangono blindati nel loro ambiente isolato.
- *Nota:* In questa modalità, interagisci con Claude esclusivamente tramite terminale (o il terminale integrato di VS Code). Evita di aprire il pannello visivo dell'estensione di VS Code per evitare sovrapposizioni tra l'account aziendale e quello personale.

---

## 🛠 3. Guida all'Installazione

###  macOS & Linux (Bash/Zsh)
1. Scarica il file `claude-profiles.sh` da questo repository e salvalo in una cartella sicura (es. la tua home).
2. Apri il file di configurazione della tua shell (`~/.zshrc` oppure `~/.bashrc`) con un editor di testo.
3. Aggiungi la seguente riga in fondo al file per caricare automaticamente i profili:
   ```bash
   source ~/claude-profiles.sh
   ```
4. Riavvia il terminale (`source ~/.zshrc`) e usa i comandi.

### 🪟 Windows (PowerShell)
1. Scarica il file `claude-profiles.ps1` da questo repository e salvalo in una cartella permanente.
2. Apri il profilo di PowerShell eseguendo questo comando nel terminale:
   ```powershell
   notepad \$PROFILE
   ```
3. Incolla la seguente riga in fondo allo script per caricare automaticamente le funzioni (fai attenzione a includere il punto iniziale e lo spazio):
   ```powershell
   . C:\percorso\della\tua\cartella\claude-profiles.ps1
   ```
4. Riavvia la console di PowerShell e testa i comandi.

---

## ⚠ 4. Stai aggiornando dalla vecchia versione con i Symlink?
Prima di lanciare le nuove funzioni, assicurati di rimuovere i vecchi collegamenti lasciati dalle precedenti configurazioni per evitare conflitti nel file system:
- **macOS/Linux:** `rm -f ~/.claude ~/.claude-mem ~/.claude-code-gui ~/.claude.json`
- **Windows (PowerShell come Amministratore):** `Remove-Item -Path "$HOME\.claude", "$HOME\.claude-mem", "$HOME\.claude-code-gui", "$HOME\.claude.json" -Force -ErrorAction SilentlyContinue`

## 📄 Licenza
Questo progetto è distribuito sotto Licenza MIT.
