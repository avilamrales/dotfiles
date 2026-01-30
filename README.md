# 🧰 Windows Dotfiles — One‑Command Dev Environment

[![OS](https://img.shields.io/badge/Platform-Windows-blue)]()
[![Script](https://img.shields.io/badge/Script-PowerShell%207-lightgrey)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)]()

A **fully automated Windows setup** for developers who want a clean, fast, and repeatable environment.

This repo installs and configures:

- 🖥 **Windows Terminal** (preconfigured)
- 🐚 **PowerShell** + **Oh My Posh** (custom prompt)
- 🧠 **Neovim** (optimized for `vscode-neovim`)
- 🧩 **VS Code** (settings, keybindings, extensions)
- 🔤 **Nerd Fonts** (FiraCode + Hack)
- 📦 **winget** apps (Git, Node, Python, ripgrep, fd, pnpm, etc.)
- ⚙️ **just** task runner to orchestrate everything

The goal: **new machine → one command → identical environment**.

---

## ✨ What You Get

- **Idempotent setup**: safe to re-run.
- **Fully scripted**: no clicking, no manual installs.
- **Opinionated but clean**: minimal, fast, keyboard‑driven.
- **VS Code + Neovim hybrid workflow**.
- **Consistent terminal + fonts + shell prompt**.

---

## 📂 Repo Structure

```
dotfiles/
├── scripts/              # All installation scripts (PowerShell)
│   ├── bootstrap.ps1     # Minimal bootstrap (pwsh + just)
│   ├── 10-ensure-apps.ps1
│   ├── 20-terminal.ps1
│   ├── 30-powershell-profile.ps1
│   ├── 40-fonts.ps1
│   ├── 50-vscode.ps1
│   ├── 60-nvim.ps1
│   └── _lib.ps1          # Shared helpers
│
├── nvim/                 # Neovim config (lazy.nvim, hop, telescope, etc.)
├── windows/              # Windows Terminal + PowerShell profile
├── oh-my-posh/           # Prompt theme
├── fonts/                # Nerd Fonts
├── justfile              # Task runner entrypoints
└── README.md
```

---

## ⚙️ How to Use

Set this up on a **fresh machine** (recommended).

---

### Option 1: Download ZIP

1. Download the latest `.zip` from:

```
https://github.com/avilamrales/dotfiles
```

2. Open **PowerShell as Administrator**, and extract the contents to:

```
$HOME/dotfiles
```

```powershell
Expand-Archive -Path $HOME\Downloads\dotfiles-main.zip -DestinationPath $HOME
Rename-Item -Path "$HOME\dotfiles-main" -NewName "dotfiles"
```

---

### Option 2: Clone via Git (If git is available)

💡 If Git is not installed, the script will install it automatically later.

1. Open **PowerShell as Administrator**, then run:

```powershell
git clone https://github.com/avilamrales/dotfiles $HOME/dotfiles
```

---

### ▶️ Run the Setup

1. Temporarily allow script execution:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

2. Run the bootstrap script:

```powershell
cd $HOME
dotfiles/scripts/bootstrap.ps1
```

3. Then run the full setup:

```powershell
just all
```

---

## 🧱 What `bootstrap.ps1` Does

- Ensures **winget** is available
- Installs **PowerShell Core (`pwsh`)**
- Installs **just**
- Then tells you to run `just all`

---

## 🏗 What `just all` Installs

In order:

1. Apps via winget (Git, Node, Python, VS Code, Terminal, etc.)
2. Windows Terminal config
3. PowerShell profile + modules
4. Fonts (⚠ requires Admin)
5. Neovim config + plugin sync
6. VS Code settings + keybindings + extensions

---

## ⚠️ Important Warnings

This setup **WILL OVERWRITE**:

- Windows Terminal settings
- VS Code user `settings.json`
- VS Code `keybindings.json`
- `%LOCALAPPDATA%\nvim`

If you have an existing setup you care about, **back it up first**.

---

## 🧠 Neovim Philosophy

- Uses **lazy.nvim**
- Designed primarily for **VS Code + vscode-neovim**
- Includes:
  - hop.nvim
  - Comment.nvim
  - nvim-surround
  - which-key.nvim
  - telescope.nvim

But also works in standalone Neovim.

---

## 🖥 PowerShell Prompt

Uses **Oh My Posh** with a custom Powerlevel10k‑style theme:

```
dotfiles/oh-my-posh/powerlevel10k.omp.json
```

Loaded automatically by:

```
windows/powershell/Microsoft.PowerShell_profile.ps1
```

---

## 🔤 Fonts

- FiraCode Nerd Font
- Hack Nerd Font

Installed system‑wide by copying to `C:\Windows\Fonts`.

⚠ This step requires **Administrator privileges**.

---

## 🧪 Running Individual Steps

You can run any step independently:

```powershell
just apps
just terminal
just profile
just fonts
just nvim
just vscode
```

---

## 🧯 If Something Fails

- Re‑run the same command — everything is idempotent.
- Make sure you’re using **PowerShell as Administrator**.
- Make sure `pwsh` is installed and accessible.
- Check the logs printed by the scripts (they are verbose on purpose).

---

## 🧭 Philosophy

> Your machine should be disposable. Your setup should not be.

This repo is your **infrastructure as code** for your dev environment.

---

## 📜 License

Do whatever you want with this. Steal it, fork it, improve it.

---

## 🧠 Notes

This repo assumes it lives at:

```
$HOME/dotfiles
```

Some paths (like the PowerShell profile and Oh My Posh theme) depend on that.

---
