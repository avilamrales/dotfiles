# Windows Dotfiles — One-Command Dev Environment

[![OS](https://img.shields.io/badge/Platform-Windows-blue)]()
[![Script](https://img.shields.io/badge/Script-PowerShell%207-lightgrey)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)]()

A fully automated Windows setup for developers who want a clean, fast, and repeatable environment. 

> "Your machine should be disposable. Your setup should not be."
> This repository serves as infrastructure-as-code for your development environment.

The goal: **new machine → one command → identical environment.**

## Features
* **Idempotent setup**: Safe to re-run at any time.
* **Opinionated but clean**: Minimal, fast, and keyboard-driven.
* **VS Code + Neovim integration**: Seamless editing experience.
* **Consistent environment**: Unified terminal, fonts, and shell prompt.

---

## What's Included

* **Windows Terminal**: Preconfigured settings.
* **PowerShell**: Includes Oh My Posh with a custom Powerlevel10k-style prompt.
* **Neovim**: Optimized for `vscode-neovim` but functional standalone. Uses `lazy.nvim` and includes `hop.nvim`, `Comment.nvim`, `nvim-surround`, `which-key.nvim`, and `telescope.nvim`.
* **VS Code**: Custom settings and keybindings.
* **Nerd Fonts**: FiraCode and Hack fonts.
* **winget apps**: Git, Node, Python, ripgrep, fd, pnpm, and more.
* **just**: A task runner to orchestrate the entire setup.

---

## Repository Structure

**Note:** This repository assumes it lives exactly at `$HOME/dotfiles`. Some paths (like the PowerShell profile and Oh My Posh theme) depend on this location.

```text
dotfiles/
├── scripts/
│   ├── bootstrap.ps1
│   ├── 10-ensure-apps.ps1
│   ├── 20-terminal.ps1
│   ├── 30-powershell-profile.ps1
│   ├── 40-fonts.ps1
│   ├── 50-vscode.ps1
│   └── _lib.ps1
│
├── nvim/
├── windows/
├── oh-my-posh/
├── fonts/
├── vscode/
├── wsl/
│   ├── setup.sh
│   ├── .zshrc
│   └── starship.toml
├── justfile
└── README.md
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
4. Install the Windows-side VS Code extensions (including Remote-WSL):
   ```powershell
   just vscode
   ```

### Step 3: Initialize and Configure WSL

Once the Windows host is prepared, you must install and configure the Windows Subsystem for Linux (WSL).

1. Open PowerShell as Administrator and install WSL (with the default Ubuntu distribution):
   ```powershell
   wsl --install
   ```
2. Restart your computer if prompted.
3. Open **Windows Terminal** and run `wsl` to initialize the environment and create your UNIX username and password.
4. Once you have a working bash prompt inside Ubuntu, run the automated Linux setup script (replace `myuser` with your actual Windows username):
   ```bash
   cp -r /mnt/c/Users/myuser/dotfiles ~/ && bash ~/dotfiles/wsl/setup.sh && exec zsh
   ```
5. Set Ubuntu as your default terminal profile:
   * Open Windows Terminal Settings (`Ctrl` + `,`).
   * Navigate to **Startup** > **Default profile** and select **Ubuntu**.
   * Click **Save**.

### Step 4: Configure Git SSH Authentication

Once your WSL environment is running, you will need to set up your SSH keys to securely clone and push to your repositories.

**See the dedicated guide:** [Git SSH Setup Instructions](git-ssh-setup.md)

---

## Architecture & Philosophy

The core philosophy of this setup is a strict separation of concerns:
* **Windows** acts solely as the **VS Code UI host**.
* **Linux (WSL)** hosts the **actual development environment**.

This separation ensures faster filesystem performance, consistent tooling across operating systems, and a fully portable development setup.

### VS Code Extensions Split
Because of this architecture, VS Code extensions are installed in two distinct places:

1. **Windows Side (`just vscode`)**: UI and bridge extensions (e.g., Remote - WSL, VS Code Neovim). These allow the Windows VS Code UI to communicate with Linux.
2. **WSL Side (`vscode/extensions.txt`)**: Development tooling (linters, language servers) is installed strictly inside WSL to keep your toolchain Linux-native.

### WSL Development Environment
All development tooling lives inside Ubuntu. Important directories managed inside WSL:
```text
~/.zshrc
~/.config/starship.toml
~/.config/nvim
~/.zsh-plugins
~/.local/share/fnm
~/.vscode-server
```

VS Code remote configurations and extensions live here:
```text
~/.vscode-server/data/Machine/settings.json
~/.vscode-server/data/Machine/keybindings.json
~/.vscode-server/extensions
```

---

## Under the Hood

### What `bootstrap.ps1` Does
* Ensures `winget` is available.
* Installs PowerShell Core (`pwsh`).
* Installs the `just` task runner.
* Prompts you to run `just all`.

### What `just all` Installs (In Order)
1. Apps via winget (Git, Node, Python, VS Code, Terminal, etc.)
2. Windows Terminal configuration.
3. PowerShell profile and modules.
4. Fonts (⚠️ Requires Administrator privileges; installs system-wide to `C:\Windows\Fonts`).
5. Neovim configuration and plugin sync.
6. VS Code settings and keybindings.

### What `setup.sh` Does
* Updates `apt` and installs essential Linux packages (`git`, `curl`, `zsh`, `neovim`, `fzf`, `ripgrep`, `bat`, `eza`, etc.).
* Sets `zsh` as the default shell and configures plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`, `fzf-tab`).
* Installs `fnm` (Fast Node Manager), the latest LTS version of Node.js, and enables `pnpm` via corepack.
* Installs and configures the `starship` cross-shell prompt.
* Copies your Linux dotfiles (`.zshrc`, `starship.toml`, `nvim` config, and VS Code Server settings).
* Installs WSL-specific VS Code extensions from `vscode/extensions.txt`.

### Oh My Posh Prompt (Windows)
Loaded automatically by `windows/powershell/Microsoft.PowerShell_profile.ps1`. The custom theme configuration is located at `dotfiles/oh-my-posh/powerlevel10k.omp.json`.

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
Just re-run the setup script inside WSL:
```bash
bash ~/dotfiles/wsl/setup.sh
```

### Manual Desktop App Installations
Some desktop applications are not installed via CLI and must be downloaded manually:

| Application | Download Link |
| :--- | :--- |
| Google Chrome | https://www.google.com/chrome |
| Proton Pass | https://proton.me/pass/download |
| Cold Turkey Blocker | https://getcoldturkey.com |
| Figma Desktop | https://www.figma.com/downloads |
| Spotify | https://www.spotify.com/download |

### Troubleshooting
If something fails during setup:
* **Re-run the command**: The scripts are idempotent and will safely pick up where they left off.
* **Permissions**: Ensure you are running PowerShell as Administrator, especially for font installation.
* **Dependencies**: Make sure `pwsh` (PowerShell Core) is installed and accessible.
* **Read the output**: The scripts are intentionally verbose; check the printed logs for specific error messages.
