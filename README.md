# Claude Code Multi-Profile Manager 🤖💼

An automated ecosystem to split, manage, and seamlessly switch between **Personal** and **Work** profiles in Anthropic's Claude Code, keeping your chat contexts alive.

Un ecosistema automatizzato per sdoppiare, gestire e scambiare i profili **Personal** (Personale) e **Work** (Lavoro) in Claude Code di Anthropic, mantenendo vivo il contesto delle tue chat.

---

## 📖 Documentation / Documentazione

Please select your preferred language for full setup instructions, architecture breakdown, and OS configurations:

Seleziona la tua lingua preferita per leggere le istruzioni di configurazione complete, i dettagli sull'architettura e le configurazioni per i vari sistemi operativi:

*   🌐 **English (International):** [README.en.md](README.en.md)
*   🇮🇹 **Italiano (Nazionale):** [README.it.md](README.it.md)

---

## 💡 What does this project solve? / Cosa risolve questo progetto?

### 1. Account Isolation / Isolamento degli Account
Prevents mixing corporate codebases and official API usage with personal coding accounts, maintaining compliance and clean security boundaries.
*Evita di mischiare basi di codice aziendali e l'uso di API ufficiali con i tuoi account di programmazione personali, mantenendo la conformità e confini di sicurezza puliti.*

### 2. The Context Loss Problem / Il Problema della Perdita del Contesto
Normally, shifting profiles triggers a token reset, causing Claude to lose track of ongoing tasks. This manager automates an **Agent Skill Handoff** to compress your workspace state (`HANDOFF.md`) before killing any active window.
*Normalmente, cambiare profilo causa un reset dei token, facendo perdere a Claude la memoria delle attività in corso. Questo gestore automatizza un **Handoff tramite Agent Skill** per comprimere lo stato del tuo spazio di lavoro (`HANDOFF.md`) prima di chiudere la sessione attiva.*

### 3. Native Integration / Integrazione Nativa
Works out-of-the-box in harmony with the **Claude Profile Switcher** extension for VS Code and Cursor, resolving annoying file-system symlink lock errors (`EEXIST`).
*Funziona istantaneamente in armonia con l'estensione **Claude Profile Switcher** per VS Code e Cursor, risolvendo i fastidiosi errori di blocco dei collegamenti simbolici (`EEXIST`) del file system.*

---

## 🛠️ Supported Environments / Ambienti Supportati

This toolkit includes tailored native scripts for maximum automation across all development platforms:
*Questo toolkit include script nativi su misura per la massima automazione su tutte le piattaforme di sviluppo:*

*   💻 **Windows:** Powered by PowerShell (`.ps1`) and specialized admin-elevated Command scripts (`.cmd`) with desktop short-cutting capabilities.
*   🍎 **macOS & 🐧 Linux:** Driven by POSIX-compliant Bash scripts (`.sh`) optimized for Unix directory permissions.

---

## 📂 Project Structure / Struttura del Progetto

```text
📁 claude-multi-profiles/
├── 📄 README.md                 <-- You are here (Intro)
├── 📄 README.it.md              <-- Full Italian Guide
├── 📄 README.en.md              <-- Full English Guide
│
├── 🌐 Windows (PC) Scripts:
│   ├── 📄 init-claude-profiles.ps1
│   ├── 📄 restore-claude-profiles.ps1
│   ├── ⚙️ start-claude-migration.cmd
│   ├── ⚙️ start-claude-restore.cmd
│   └── ⚙️ make-shortcut.cmd
│
└── 🍎/🐧 Unix Scripts:
    ├── 📄 init-claude-profiles.sh
    ├── 📄 restore-claude-profiles.sh
    ├── 📄 start-claude-migration.sh
    └── 📄 start-claude-restore.sh
```
