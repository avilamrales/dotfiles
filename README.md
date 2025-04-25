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

Set this up on a fresh machine:

### Option 1: Download ZIP

1. Download the latest `.zip` from https://github.com/avilamrales/dotfiles

2. Open **PowerShell as Administrator**, and extract the contents to: `$HOME/dotfiles`

```powershell
Expand-Archive -Path $HOME\Downloads\dotfiles-main.zip -DestinationPath $HOME
Rename-Item -Path "$HOME\dotfiles-main" -NewName "dotfiles"
```

### Option 2: Clone via Git (If git is available)

💡 If Git is not installed, the script will install it automatically.

1. Open **PowerShell as Administrator**, then run the next command to clone the `dotfiles` folder:

```powershell
git clone https://github.com/avilamrales/dotfiles $HOME/dotfiles
```

### Run the Setup

1. Temporarily allow script execution:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

2. Run the installation script:

```powershell
cd $HOME
dotfiles/install-dev-env.ps1
```

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
