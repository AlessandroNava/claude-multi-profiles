# Claude Code Multi-Account Setup for macOS and Linux

This guide provides the shell scripts required to configure seamless profile switching on Unix-based systems using native symlinks.

---

## 🛠️ How to Run Shell Scripts (.sh)

By default, newly created or downloaded `.sh` files lack execution permissions on Unix systems. Follow these steps to run them successfully:

1. Close **VS Code** completely.
2. Open your **Terminal** and navigate to the directory where your `.sh` files are stored using the `cd` command (e.g., your Downloads folder):
   ```bash
   cd \$HOME/Downloads
   ```
3. Grant execution permissions to both scripts using the `chmod` command:
   ```bash
   chmod +x init-claude-personal.sh setup-claude-profiles.sh
   ```
4. Execute the initialization script to migrate your files:
   ```bash
   ./init-claude-personal.sh
   ```
5. Next, run the profile manager configuration script to update your shell:
   ```bash
   ./setup-claude-profiles.sh
   ```
6. Reload your terminal settings or type `source ~/.zshrc` to activate the changes immediately.

---

## 1. Step 1: Initialization and Data Migration
*   **Filename:** `init-claude-personal.sh`
*   **Instructions:** Close **VS Code** completely. Open your terminal, grant execution permissions to the script, and run it.

```bash
#!/bin/bash

FOLDERS=(
    "Core:\(HOME/.claude:\)HOME/.claude-personal"
    "Memory:\(HOME/.claude-mem:\)HOME/.claude-mem-personal"
    "GUI:\(HOME/.claude-code-gui:\)HOME/.claude-code-gui-personal"
)

echo "Starting Claude folder migration for the PERSONAL profile..."
echo "---------------------------------------------------------"

for entry in "\${FOLDERS[@]}"; do
    IFS=":" read -r name old_path new_path <<< "\$entry"
    if [ -d "\(old_path" ] && [ ! -L "\)old_path" ]; then
        if [ -d "\$new_path" ]; then
            echo "[!] Warning: Target directory '\$new_path' already exists. Skipping rename."
        else
            mv "\(old_path" "\)new_path"
            echo "[✓] \(name successfully migrated to:\)new_path"
        fi
    fi
done

# Migrate global MCP configuration file
if [ -f "\(HOME/.claude.json" ] && [ ! -L "\)HOME/.claude.json" ]; then
    mv "\(HOME/.claude.json" "\)HOME/.claude-personal.json"
    echo "[✓] Global MCP file migrated to ~/.claude-personal.json"
fi

# Pre-populate Work environment: copy global commands, skills, and rules from Pro for onboarding
mkdir -p "\$HOME/.claude-work"
for item in commands skills CLAUDE.md; do
    if [ -e "\(HOME/.claude-personal/\)item" ]; then
        cp -r "\$HOME/.claude-personal/\(item" "\)HOME/.claude-work/"
        echo "[➔] Copied '\$item' into the work profile directory."
    fi
done

echo "---------------------------------------------------------"
echo "[COMPLETED] You can now proceed to run setup-claude-profiles.sh"
```
*Execution commands:*
```bash
chmod +x init-claude-personal.sh && ./init-claude-personal.sh
```

---

## 2. Step 2: Zsh Shell Environment Update
*   **Filename:** `setup-claude-profiles.sh`
*   **Instructions:** Run this script to permanently append the switching logic at the end of your `~/.zshrc` file.

```bash
#!/bin/bash

echo "Appending profile-switching functions into ~/.zshrc..."

cat << 'EOF' >> "\$HOME/.zshrc"

# === ADVANCED CLAUDE CODE MULTI-ACCOUNT CONFIGURATION ===
set-claude-profile() {
    local target=\$1
    
    # Safely clear active symbolic links (keeps actual directory data intact)
    rm -f "\(HOME/.claude" "\)HOME/.claude-mem" "\(HOME/.claude-code-gui" "\)HOME/.claude.json"

    if [ "\$target" = "personal" ]; then
        mkdir -p "\$HOME/.claude-personal"
        ln -s "\(HOME/.claude-personal" "\)HOME/.claude"
        ln -s "\(HOME/.claude-mem-personal" "\)HOME/.claude-mem" 2>/dev/null || true
        ln -s "\(HOME/.claude-code-gui-personal" "\)HOME/.claude-code-gui" 2>/dev/null || true
        [ -f "\$HOME/.claude-personal.json" ] && ln -s "\(HOME/.claude-personal.json" "\)HOME/.claude.json"
        echo -e "\033[0;36m[⇄] Active Profile: PERSONAL (Pro + MCP)\033[0m"
        
    elif [ "\$target" = "work" ]; then
        mkdir -p "\$HOME/.claude-work" "\(HOME/.claude-mem-work" "\)HOME/.claude-code-gui-work"
        [ ! -f "\(HOME/.claude-work.json" ] && echo "{}" > "\)HOME/.claude-work.json"
        
        ln -s "\(HOME/.claude-work" "\)HOME/.claude"
        ln -s "\(HOME/.claude-mem-work" "\)HOME/.claude-mem"
        ln -s "\(HOME/.claude-code-gui-work" "\)HOME/.claude-code-gui"
        ln -s "\(HOME/.claude-work.json" "\)HOME/.claude.json"
        echo -e "\033[0;35m[⇄] Active Profile: WORK (Team + MCP)\033[0m"
    fi
}

# Advanced shortcuts to trigger context swap and CLI initialization at once
claude-personal() { set-claude-profile "personal"; claude "\$@"; }
claude-work()     { set-claude-profile "work"; claude "\$@"; }
# ==================================================================
EOF

echo "[✓] Configurations saved! Run 'source ~/.zshrc' to apply immediately."
```
*Execution commands:*
```bash
chmod +x setup-claude-profiles.sh && ./setup-claude-profiles.sh && source ~/.zshrc
```
