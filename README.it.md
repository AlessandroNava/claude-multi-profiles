# Gestore Multi-Profilo Claude Code 🤖💼

Questo ecosistema di script permette di sdoppiare l'ambiente di Claude Code in due profili indipendenti (**Personal** e **Work**), integrandosi con l'estensione *Claude Profile Switcher* e automatizzando il salvataggio delle sessioni tramite la skill `handoff`.

---

## 💻 Ambiente: WINDOWS

### Requisiti
* Windows PowerShell 5.1 o superiore (o PowerShell 7+).
* Diritti di Amministratore (richiesti automaticamente dai file `.cmd`).

### File inclusi per Windows
* `init-claude-profiles.ps1` — Logica di sdoppiamento cartelle.
* `restore-claude-profiles.ps1` — Logica di ripristino del sistema.
* `start-claude-migration.cmd` — Avvia lo switch da Personal a Work con Handoff automatico.
* `start-claude-restore.cmd` — Avvia il ripristino da Work a Personal con Handoff automatico.
* `make-shortcut.cmd` — Genera le icone di avvio rapido sul Desktop.

### Operazioni da fare (Windows)
1. Inserisci tutti i file forniti all'interno di una cartella dedicata (es. `C:\Users\tuo_utente\Scripts\claude-profiles`).
2. Fai doppio clic su **`make-shortcut.cmd`**: questo creerà due icone sul tuo Desktop pronte all'uso.
3. Chiudi VS Code, Cursor e qualsiasi terminale attivo.
4. Per passare al profilo aziendale, fai doppio clic su **`Claude - Avvia Migrazione`** sul Desktop. Lo script:
   - Salverà il contesto corrente in `HANDOFF.md`.
   - Chiuderà i processi bloccanti.
   - Creerà e sincronizzerà le cartelle dei profili.
5. Apri l'estensione *Claude Profile Switcher* su VS Code e imposta i percorsi per `.claude-personal` e `.claude-work`.
6. Nella nuova sessione del profilo Work, digita in chat `leggi HANDOFF.md` per riprendere il lavoro da dove lo avevi interrotto.

---

## 🍎 / 🐧 Ambiente: UNIX (macOS / Linux)

### Requisiti
* Shell Bash (predefinita su Linux e disponibile su macOS).
* Permessi di esecuzione sui file `.sh`.

### File inclusi per Unix
* `init-claude-profiles.sh` — Logica Unix di sdoppiamento cartelle.
* `restore-claude-profiles.sh` — Logica Unix di ripristino del sistema.
* `start-claude-migration.sh` — Avvia lo switch Unix con Handoff automatico.
* `start-claude-restore.sh` — Avvia il ripristino Unix con Handoff automatico.

### Operazioni da fare (Unix / macOS / Linux)
1. Salva i file `.sh` in una cartella a tua scelta (es. `~/claude-profiles`).
2. Apri il terminale del tuo Mac o Linux e spostati nella cartella in cui hai salvato i file:
   ```bash
   cd ~/claude-profiles
   ```
3. **Abilita i permessi di esecuzione** per tutti gli script digitando:
   ```bash
   chmod +x *.sh
   ```
4. Per migrare al profilo Work, esegui il file di lancio digitando:
   ```bash
   ./start-claude-migration.sh
   ```
5. Lo script salverà automaticamente lo stato corrente del terminale in `HANDOFF.md`, arresterà le istanze di Claude e preparerà i percorsi fisici in `~/.claude-personal` e `~/.claude-work`.
6. Apri il nuovo profilo e digita in chat `/compact` o `leggi HANDOFF.md` per ripristinare la sessione precedente.

---
## ⚙️ Personalizzazione dei Suffissi delle Cartelle

Se desideri cambiare il nome delle cartelle generate sul computer (ad esempio, utilizzare `-private` al posto di `-personal` o `-azienda` al posto di `-work`), ti basta modificare una sola riga all'inizio degli script principali.

### Su Windows (In `init-claude-profiles.ps1` e `restore-claude-profiles.ps1`)
Apri i file `.ps1` con un editor di testo e individua la sezione `CONFIGURAZIONE PARAMETRIZZATA`. Modifica i valori tra virgolette:
```powershell
\$SuffixP   = "-private"   # Cambia il nome del profilo Personale
\$SuffixW   = "-azienda"   # Cambia il nome del profilo Lavoro
```

### Su Unix / macOS / Linux (In `init-claude-profiles.sh` e `restore-claude-profiles.sh`)
Apri i file `.sh` e modifica le variabili corrispondenti nella parte alta del codice:
```bash
SUFFIX_P="-private"       # Cambia il nome del profilo Personale
SUFFIX_W="-azienda"       # Cambia il nome del profilo Lavoro
```

*Nota: Se modifichi i suffissi a migrazione già avvenuta, ricordati di aggiornare anche i percorsi all'interno delle impostazioni dell'estensione "Claude Profile Switcher" su VS Code/Cursor.*

## 🪵 Registro dei Log e Diagnostica
Entrambi gli ambienti generano e aggiornano un file di testo condiviso sul tuo Desktop chiamato **`Claude_Migration_Log.txt`**. All'interno troverai la cronologia con timestamp di ogni operazione eseguita, inclusi i successi di copia della skill di handoff ed eventuali errori di file bloccati.
