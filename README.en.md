# Claude Code Multi-Profile Manager 🤖💼

This script ecosystem allows you to split your Claude Code environment into two independent profiles (**Personal** and **Work**). It integrates perfectly with the *Claude Profile Switcher* extension and automates session handoffs via the custom `handoff` skill.

---

## 💻 Environment: WINDOWS

### Requirements
* Windows PowerShell 5.1 or higher (or PowerShell 7+).
* Administrator Privileges (automatically requested by `.cmd` files).

### Included Files for Windows
* `init-claude-profiles.ps1` — Folder splitting logic.
* `restore-claude-profiles.ps1` — System restore logic.
* `start-claude-migration.cmd` — Starts Personal to Work switch with automatic Handoff.
* `start-claude-restore.cmd` — Starts Work to Personal restore with automatic Handoff.
* `make-shortcut.cmd` — Generates Desktop quick-launch shortcuts.

### Step-by-Step Instructions (Windows)
1. Place all provided files into a dedicated folder (e.g., `C:\Users\your_user\Scripts\claude-profiles`).
2. Double-click **`make-shortcut.cmd`**: this will generate two ready-to-use shortcut icons on your Desktop.
3. Close VS Code, Cursor, and any active terminal instance.
4. To switch to your work profile, double-click **`Claude - Avvia Migrazione`** on your Desktop. The script will:
   - Save your current chat context to `HANDOFF.md`.
   - Force-close any locking processes.
   - Setup and synchronize profile directories.
5. Open the *Claude Profile Switcher* extension in VS Code and set the paths to point to `.claude-personal` and `.claude-work`.
6. In your new Work profile session, type `read HANDOFF.md` in the chat to pick up exactly where you left off.

---

## 🍎 / 🐧 Environment: UNIX (macOS / Linux)

### Requirements
* Bash Shell (default on Linux, native on macOS).
* Execution permissions enabled on `.sh` files.

### Included Files for Unix
* `init-claude-profiles.sh` — Folder splitting logic for Unix.
* `restore-claude-profiles.sh` — System restore logic for Unix.
* `start-claude-migration.sh` — Starts Unix profile switch with automatic Handoff.
* `start-claude-restore.sh` — Starts Unix profile restore with automatic Handoff.

### Step-by-Step Instructions (Unix / macOS / Linux)
1. Save the `.sh` files into a directory of your choice (e.g., `~/claude-profiles`).
2. Open your Mac or Linux Terminal and navigate to the scripts folder:
   ```bash
   cd ~/claude-profiles
   ```
3. **Grant execution permissions** to all scripts by running:
   ```bash
   chmod +x *.sh
   ```
4. To migrate to your Work profile, execute the launch script by running:
   ```bash
   ./start-claude-migration.sh
   ```
5. The script will automatically dump your terminal session context into `HANDOFF.md`, terminate background Claude instances, and set up physical folder structures in `~/.claude-personal` and `~/.claude-work`.
6. Open your new profile session and type `read HANDOFF.md` or invoke `/compact` to restore your working history.

---
## ⚙️ Customizing Folder Suffixes

If you want to rename the generated profile folders on your system (for example, using `-private` instead of `-personal` or `-company` instead of `-work`), you can easily do so by changing a single line at the top of the core scripts.

### On Windows (Inside `init-claude-profiles.ps1` and `restore-claude-profiles.ps1`)
Open the `.ps1` files with a text editor and locate the `CONFIGURAZIONE PARAMETRIZZATA` section. Modify the values inside the quotes:
```powershell
\$SuffixP   = "-private"   # Changes the Personal profile folder name
\$SuffixW   = "-company"   # Changes the Work profile folder name
```

### On Unix / macOS / Linux (Inside `init-claude-profiles.sh` and `restore-claude-profiles.sh`)
Open the `.sh` files and update the corresponding variables near the top of the file:
```bash
SUFFIX_P="-private"       # Changes the Personal profile folder name
SUFFIX_W="-company"       # Changes the Work profile folder name
```

*Note: If you change these suffixes after a migration has already been executed, make sure to update the directory paths inside the "Claude Profile Switcher" extension settings in VS Code/Cursor accordingly.*

## 🪵 Activity Logs and Diagnostics
Both environments dynamically generate and update a shared text log on your Desktop named **`Claude_Migration_Log.txt`**. Inside, you will find a timestamped history of every operation executed, including successful copies of the handoff skill and any file-system errors.
