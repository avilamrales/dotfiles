# justfile 🧰 task runner for dotfiles

# Runs full PowerShell bootstrap setup
bootstrap:
    powershell ./install-dev-env.ps1

# Sync Neovim config only
sync-nvim:
    cp -r ./nvim "$env:LOCALAPPDATA\nvim"

# Re-apply VS Code settings + extensions
sync-vscode:
    cp ./vscode-config/settings.json "$env:APPDATA\\Code\\User\\settings.json"
    cp ./vscode-config/keybindings.json "$env:APPDATA\\Code\\User\\keybindings.json"
    type ./vscode-config/extensions.txt | foreach { code --install-extension $_ }

# Show basic info
info:
    echo "Dotfiles installed via PowerShell"
    echo "Fonts, VS Code, Neovim, PowerShell profile, Terminal config"
