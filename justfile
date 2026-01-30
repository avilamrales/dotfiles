# justfile 🧰 task runner for dotfiles (Windows)

# Always run scripts with PowerShell Core + process-scoped ExecutionPolicy bypass
set shell := ["pwsh", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]

bootstrap:
    @./scripts/bootstrap.ps1

# Ensures winget exists (mostly useful for troubleshooting)
winget:
    @./scripts/00-winget.ps1

# Installs your regular apps/tools (NOT part of minimal bootstrap)
apps:
    @./scripts/10-ensure-apps.ps1

terminal:
    @./scripts/20-terminal.ps1

profile:
    @./scripts/30-powershell-profile.ps1

fonts:
    @./scripts/40-fonts.ps1

vscode:
    @./scripts/50-vscode.ps1

nvim:
    @./scripts/60-nvim.ps1

all:
    @just apps
    @just terminal
    @just profile
    @just fonts
