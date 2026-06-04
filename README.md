# claude-multi-profiles

[![Platform](https://img.shields.io/badge/Platform-8A2BE2
)](./)
[![Language](https://img.shields.io/badge/Language%3A%20EN-orange)](./README.it.md)
[![License: MIT](https://img.shields.io/badge/License%3A%20MIT-brightgreen
)](https://opensource.org)

> Scripts and documentation to seamlessly switch between multiple Claude Code accounts (Personal/Pro & Team/Work) on Windows, macOS, and Linux.

🇮🇹 **Nota per gli utenti italiani:** È disponibile la documentazione completa in lingua italiana nel file [README.it.md](./README.it.md).

---

## 📐 1. How It Works (Architecture)

Both the VS Code graphical extension and the official Claude Code CLI strictly look for specific fixed directories in your user home path (`~` or `%USERPROFILE%`). If you log in with a Team account, your existing Pro tokens and history are overwritten.

This project solves the issue at its root by **replacing real folders and files with Symbolic Links (Symlinks/Junctions)**.

### Directory Structure on Your PC

*   **Real Physical Environment (Isolated):**
    *   `.claude-personal` / `.claude-work` → Session tokens, agent cache, global commands.
    *   `.claude-mem-personal` / `.claude-mem-work` → Long-term memory (*Auto-memory*).
    *   `.claude-code-gui-personal` / `.claude-code-gui-work` → VS Code graphical extension cache.
    *   `.claude-personal.json` / `.claude-work.json` → Global **MCP** (Model Context Protocol) configurations.
*   **Logical Environment (Active symlinks read by VS Code & CLI):**
    *   `.claude` → *(points to personal OR work)*
    *   `.claude-mem` → *(points to personal OR work)*
    *   `.claude-code-gui` → *(points to personal OR work)*
    *   `.claude.json` → *(points to personal OR work)*

When you execute the switch command, the symlinks swap instantly. **Both your terminal and the VS Code extension will immediately follow the activated profile.**

---

## 🚀 2. Daily Workflow

Once installed, **avoid typing the raw native `claude` command by itself**. Always use the dedicated quick commands to automatically swap the profile context before launching Claude:

### 👤 Scenario A: Personal Projects / Private Development (Pro)
Open your terminal and type:
```bash
claude-personal
```
*   **What happens:** Symlinks connect to the `-personal` folders. VS Code and the CLI inherit your old logins, historical memories, and private MCP configurations.

### 🏢 Scenario B: Corporate Projects / Client Code (Team)
Open your terminal and type:
```bash
claude-work
```
*   **What happens:** Symlinks point to `.claude-work`.
*   **First launch only:** Claude Code detects a clean environment. The browser will open asking for your login. Enter your **Corporate/Team/Enterprise** credentials.
*   **Subsequent launches:** You are immediately operational. Your work history and corporate MCP servers remain tightly sandboxed.

---

## 🛠️ 3. OS-Specific Setup Guides

Select the guide corresponding to your operating system to find the initialization and setup scripts:

*   👉 **[WINDOWS.md](./WINDOWS.md)**: Setup guide, `init-claude-personal.ps1`, and `setup-claude-profiles.ps1` for Windows 11 (PowerShell).
*   👉 **[UNIX.md](./UNIX.md)**: Setup guide, `init-claude-personal.sh`, and `setup-claude-profiles.sh` for macOS & Linux (Zsh/Bash).

---

## ⚠️ 4. Troubleshooting

*   **"Access Denied / File Locked" during migration:**
    Make sure **VS Code** is completely closed and no background `claude` processes are running in your Task Manager / Activity Monitor.
*   **Symlinks do not change or the GUI extension shows the wrong account:**
    If VS Code was open while you ran the switch command, the IDE might have cached the session. Restart VS Code to force it to re-read the updated symlinks.
*   **"Cannot create a file when that file already exists" (Windows):**
    The script found a real folder where a symlink junction should be. Manually delete the empty `.claude` folder from your user directory (after ensuring your actual data is safe inside `.claude-personal` or `.claude-work`) and re-run the switch command.

---

## 🛠️ How to Run PowerShell Scripts (.ps1) on Windows 11

By default, Windows blocks script execution for security reasons. Follow these steps to run the scripts successfully:

1. Close **VS Code** completely.
2. Open **PowerShell** and navigate to the folder where your scripts are saved using the `cd` command:
   ```powershell
   cd "C:\Path\To\Your\Folder"
   ```
3. Temporarily unblock script execution for your current terminal session by running:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
   ```
4. Execute the initialization script by typing its name preceded by `.\`:
   ```powershell
   .\init-claude-personal.ps1
   ```
5. Next, execute the profile manager setup script:
   ```powershell
   .\setup-claude-profiles.ps1
   ```
6. Restart your terminal to apply the changes.


## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
