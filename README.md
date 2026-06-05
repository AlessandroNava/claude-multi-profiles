# claude-multi-profiles

Scripts and documentation to seamlessly switch between multiple Claude Code accounts (Personal/Pro & Team/Work) on Windows, macOS, and Linux without token or session conflicts.

🇮🇹 **Nota per gli utenti italiani:** È disponibile la documentazione completa in lingua italiana nel file README.it.md.

## 📐 1. How It Works

By default, the official Claude Code CLI and the VS Code graphical extension look for fixed directories in your user home path to store session tokens, history, and MCP configurations. 

Instead of using unstable symbolic links that corrupt the OS Keychain and cause frequent logouts, this project leverages the native environment variable **`CLAUDE_CONFIG_DIR`**.

### Architecture
- **Personal / Pro Profile (Default):** Shares the native `~/.claude` folder. This allows **both your terminal and the VS Code graphical extension** to share your private Pro login, memories, and settings natively.
- **Work / Team Profile (Isolated):** Diverted into an isolated directory (`~/.claude-work`). This sandboxes your corporate tokens, client chat logs, and business MCP servers entirely inside the terminal environment.

---

## 🚀 2. Daily Workflow

Once configured, use the dedicated functions depending on your current project context:

### 👤 Scenario A: Personal Projects / Private Development (Pro)
Open your terminal and type:
```bash
claude-personal
```
- **What happens:** The environment variable is cleared, restoring the default system behavior. **Both your terminal and your VS Code graphical extension panel** will instantly target your personal Pro login and private history.

### 🏢 Scenario B: Corporate Projects / Client Code (Team)
Open your terminal and type:
```bash
claude-work
```
- **What happens:** The CLI diverts its configuration folder to `~/.claude-work`. Your corporate tokens and work sessions are kept entirely separated.
- *Note:* In this mode, interact with Claude strictly via the terminal (or the integrated terminal inside VS Code). Avoid opening the VS Code graphical panel to prevent corporate/personal account overlaps.

---

## 🛠 3. Setup Guides

###  macOS & Linux (Bash/Zsh)
1. Download the `claude-profiles.sh` file from this repository and save it in a safe place (e.g., your home directory).
2. Open your shell configuration file (`~/.zshrc` or `~/.bashrc`) with a text editor.
3. Add the following line at the end of the file to auto-load the profiles:
   ```bash
   source ~/claude-profiles.sh
   ```
4. Reload your terminal (`source ~/.zshrc`) and you are ready to use the commands.

### 🪟 Windows (PowerShell)
1. Download the `claude-profiles.ps1` file from this repository and save it in a permanent folder.
2. Open your PowerShell profile by running this command in your terminal:
   ```powershell
   notepad \$PROFILE
   ```
3. Paste the following line at the bottom of the script to automatically load the functions (include the leading dot and space):
   ```powershell
   . C:\(\path\to\your\folder\claude-\)profiles.ps1
   ```
4. Restart your PowerShell console and test the commands.

---

## ⚠ 4. Upgrading from old Symlink version?
Before using the new functions, make sure to safely delete any old link left by previous migrations:
- **macOS/Linux:** `rm -f ~/.claude ~/.claude-mem ~/.claude-code-gui ~/.claude.json`
- **Windows (Admin PowerShell):** `Remove-Item -Path "$HOME\.claude", "$HOME\.claude-mem", "$HOME\.claude-code-gui", "$HOME\.claude.json" -Force -ErrorAction SilentlyContinue`

## 📄 License
This project is licensed under the MIT License.
