# Windows Dotfiles — One-Command Dev Environment

[![OS](https://img.shields.io/badge/Platform-Windows-blue)]()
[![Script](https://img.shields.io/badge/Script-PowerShell%207-lightgrey)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)]()

A fully automated Windows setup for developers who want a clean, fast, and repeatable environment.

> "Your machine should be disposable. Your setup should not be."
> This repository serves as infrastructure-as-code for your development environment.

The goal: **new machine → one command → identical environment.**

## Features

- **Idempotent setup**: Safe to re-run at any time.
- **Opinionated but clean**: Minimal, fast, and keyboard-driven.
- **Neovim integration**: Seamless editing experience, with standalone LazyVim for pure terminal usage.
- **Consistent environment**: Unified terminal, fonts, and shell prompt.
- **Modern Tooling**: Powered by `mise` for seamless version management across WSL.
- **WSL Optimization**: Automatically disables `systemd` for faster startup, with an easy opt-in flag if needed.

---

## What's Included

- **Windows Terminal**: Preconfigured settings.
- **PowerShell**: Includes Oh My Posh with a custom Powerlevel10k-style prompt.
- **Neovim**: Full standalone IDE experience via **LazyVim** (in `nvim/`). A separate, optimized configuration exists for VS Code integration (in `nvim-vscode/`).
- **VS Code**: Custom settings and keybindings.
- **Nerd Fonts**: FiraCode and Hack fonts.
- **mise**: Replaces traditional package managers in WSL to handle Node, Bun, Neovim, and core CLI tools.
- **CLI Utilities**: fzf, ripgrep, fd, bat, eza, and starship prompt.
- **just**: A task runner to orchestrate the windows setup.

---

## Repository Structure

**Note:** This repository assumes it lives exactly at `$HOME/dotfiles`. Some paths depend on this location.

```text
dotfiles/
├── README.md
├── fonts/
│   ├── FiraCode-Bold.ttf
│   ├── FiraCode-Regular.ttf
│   ├── Hack-Bold.ttf
│   ├── Hack-Italic.ttf
│   └── Hack-Regular.ttf
├── git-ssh-setup.md
├── justfile
├── nvim/                 # Full LazyVim standalone configuration
├── nvim-vscode/          # Legacy Neovim configuration optimized for vscode-neovim
├── oh-my-posh/
├── scripts/
│   ├── 00-winget.ps1
│   ├── 10-ensure-apps.ps1
│   ├── 20-terminal.ps1
│   ├── 30-powershell-profile.ps1
│   ├── 40-fonts.ps1
│   ├── 50-vscode.ps1
│   ├── _lib.ps1
│   └── bootstrap.ps1
├── vscode/
│   ├── extensions.txt
│   ├── keybindings.json
│   ├── settings.json
│   └── windows-extensions.txt
├── windows/
│   ├── powershell/
│   └── terminal/
└── wsl/
    ├── .zshrc
    ├── setup.sh
    └── starship.toml
```

---

## Installation Guide

It is highly recommended to run this on a **fresh machine**.

### Step 1: Download the Repository

Choose one of the following methods to place the repository in `$HOME/dotfiles`.

**Option A: Download ZIP**

```powershell
Expand-Archive -Path $HOME\Downloads\dotfiles-main.zip -DestinationPath $HOME
Rename-Item -Path "$HOME\dotfiles-main" -NewName "dotfiles"
```

**Option B: Clone via Git**

```powershell
git clone https://github.com/avilamrales/dotfiles $HOME/dotfiles
```

### Step 2: Run the Windows Setup

1. Allow script execution for your current session:

   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   ```

2. Run the bootstrap script:

   ```powershell
   cd $HOME
   dotfiles/scripts/bootstrap.ps1
   ```

3. Run the full environment setup:

   ```powershell
   just all
   ```

4. Install the Windows-side VS Code extensions:

   ```powershell
   just vscode
   ```

### Step 3: Initialize and Configure WSL

Once the Windows host is prepared, configure the Windows Subsystem for Linux (WSL).

1. Open PowerShell as Administrator and install WSL:

   ```powershell
   wsl --install
   ```

2. Restart your computer if prompted.
3. Open **Windows Terminal** and run `wsl` to initialize the environment and create your UNIX username and password.
4. Once you have a working bash prompt inside Ubuntu, run the automated Linux setup script.

   _Note: This script disables `systemd` by default for a faster, lighter WSL environment. If your workflow requires `systemd`, append the `--enable-systemd` flag._

   ```bash
   cp -rf /mnt/c/Users/my-windows-username/dotfiles ~/

   # Default run (Disables systemd)
   bash ~/dotfiles/wsl/setup.sh && exec zsh

   # Alternative run (Keeps systemd enabled)
   # bash ~/dotfiles/wsl/setup.sh --enable-systemd && exec zsh
   ```

5. Set Ubuntu as your default terminal profile in Windows Terminal Settings.

### Step 4: Configure Git SSH Authentication

You will need to set up your SSH keys to securely clone and push to your repositories.

**See the dedicated guide:** [Git SSH Setup Instructions](git-ssh-setup.md)

---

## Architecture & Philosophy

The core philosophy of this setup is a strict separation of concerns:

- **Windows** acts solely as the **UI host** (VS Code, Terminal).
- **Linux (WSL)** hosts the **actual development environment**.

### Dual Neovim Configurations

Because of this split architecture, Neovim is configured for two distinct use cases:

1. **`nvim/` (LazyVim)**: A fully-featured standalone terminal IDE used directly inside WSL.
2. **`nvim-vscode/`** (needs to be set up manually): A lightweight configuration designed specifically to act as the backend for the `vscode-neovim` extension in the Windows UI.

### WSL Development Environment

All development tooling lives inside Ubuntu. Important directories mapped inside WSL via symlinks:

```text
~/.zshrc -> ~/dotfiles/wsl/.zshrc
~/.config/starship.toml -> ~/dotfiles/wsl/starship.toml
~/.config/nvim -> ~/dotfiles/nvim
```

---

## Under the Hood

### What `bootstrap.ps1` Does

- Ensures `winget` is available and configured.
- Installs PowerShell Core (`pwsh`).
- Installs the `just` task runner.

### What `setup.sh` (WSL) Does

- **Core Systems**: Updates `apt` and installs compilation basics (`build-essential`, `git`, `curl`, `zsh`).
- **Mise Installation**: Installs `mise` to manage all toolchains without relying on `apt` or `snap`.
- **Toolchain Setup**: Uses `mise` to pull down `node`, `bun`, `neovim`, `fzf`, `ripgrep`, `bat`, `eza`, and `starship`.
- **Symlinking**: Securely backs up existing configs and symlinks your `.zshrc`, `starship.toml`, and Neovim configurations directly to the repository so changes track automatically.
- **LazyVim Bootstrap**: Automatically launches a headless Neovim instance to sync and install all LazyVim plugins.

---

## Maintenance & Usage

### Running Individual Steps

Because the scripts are idempotent, you can run any step independently to repair or update your setup:

**Windows (`justfile`):**

```powershell
just apps
just terminal
just profile
just fonts
just vscode
```

**Linux (`setup.sh`):**
Just re-run the setup script inside WSL. You can append `--enable-systemd` if you wish to change that setting later.

```bash
bash ~/dotfiles/wsl/setup.sh
```

### Manual Desktop App Installations

Some desktop applications are not installed via CLI and must be downloaded manually:

| Application         | Download Link                      |
| :------------------ | :--------------------------------- |
| Google Chrome       | <https://www.google.com/chrome>    |
| Proton Pass         | <https://proton.me/pass/download>  |
| Cold Turkey Blocker | <https://getcoldturkey.com>        |
| Figma Desktop       | <https://www.figma.com/downloads>  |
| Spotify             | <https://www.spotify.com/download> |

### Troubleshooting

If something fails during setup:

- **Re-run the command**: The scripts are idempotent and will safely pick up where they left off.
- **Permissions**: Ensure you are running PowerShell as Administrator, especially for font installation.
- **Read the output**: The scripts are intentionally verbose; check the printed logs for specific error messages.
