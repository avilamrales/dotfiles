# 🚀 My Dotfiles (PowerShell + Neovim + VS Code)

[![OS](https://img.shields.io/badge/Platform-Windows-blue)]()
[![Script](https://img.shields.io/badge/Script-PowerShell%207-lightgrey)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)]()

---

## ✅ What This Script Sets Up

- Windows Terminal with settings + fonts
- PowerShell with Oh-My-Posh, Terminal Icons, and custom aliases
- VS Code:
  - Settings
  - Keybindings
  - Extensions
- Neovim:
  - Installs if missing
  - Copies my config
- Essential Dev Tools:
  - Git
  - Node.js (LTS)
  - Python 3
  - Neovim CLI
  - ripgrep, fd, 7zip
  - Justfile task runner

---

## ⚙️ How to Use

On a fresh machine (with PowerShell Core):

```powershell
git clone https://github.com/your-username/dotfiles
cd dotfiles
./install-dev-env.ps1
```

✅ Make sure you run PowerShell as administrator

---

## 🧰 Justfile Tasks

Once `just` is installed (automatically by the script), you can use CLI shortcuts like this:

```powershell
just bootstrap
just sync-nvim
just sync-vscode
just info
```

## Available Tasks

| Task        | Description                                                   |
| ----------- | ------------------------------------------------------------- |
| bootstrap   | Runs the full PowerShell bootstrap script                     |
| sync-nvim   | Copies your Neovim config to $LOCALAPPDATA\nvim               |
| sync-vscode | Reapplies VS Code settings, keybindings, and extensions       |
| info        | Displays a quick overview of what the dotfiles setup includes |

---
