# justfile 🧰 task runner for dotfiles

# Use latest PowerShell Core
set shell := ["pwsh", "-NoProfile", "-Command"]

# Runs full PowerShell bootstrap setup
bootstrap:
    @./install-dev-env.ps1

# Sync Neovim config only
sync-nvim:
    @Remove-Item -Recurse -Force "$env:LOCALAPPDATA\\nvim"
    @nvim --headless +"qa"
    @cp -r ./nvim "$env:LOCALAPPDATA\\nvim" -Force
    @nvim +"Lazy sync" +"qa"

# Re-apply VS Code settings + extensions
sync-vscode:
    @cp ./nvim/vscode-config/settings.json "$env:APPDATA\\Code\\User\\settings.json"
    @cp ./nvim/vscode-config/keybindings.json "$env:APPDATA\\Code\\User\\keybindings.json"
    @Get-Content ./nvim/vscode-config/extensions.txt | ForEach-Object { code --install-extension $_ }

# Show basic info
# info:
#    @Write-Host "Dotfiles installed via PowerShell Core"
#    @Write-Host "Fonts, VS Code, Neovim, PowerShell profile, Terminal config"
