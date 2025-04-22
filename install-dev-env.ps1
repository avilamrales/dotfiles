# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃  Dotfiles Bootstrap (PowerShell/Win)  ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# ─────────────────────────────────────────────────────────────────────────────
# Define a helper function to install apps via winget with auto-accept
function Install-App($id) {
    Write-Host "📦 Installing $id..."
    winget install --id $id -e --accept-package-agreements --accept-source-agreements
}

Write-Host "`n🔍 Detecting current shell..."
$shell = $PSVersionTable.PSEdition

if ($shell -eq "Core") {
    Write-Host "✅ Using PowerShell Core (pwsh)."
} elseif ($shell -eq "Desktop") {
    Write-Host "✅ Using Windows PowerShell (legacy)."
} else {
    Write-Host "⚠️ Unknown shell. This script is built for PowerShell."
    exit 1
}

# ─────────────────────────────────────────────────────────────────────────────
# 1. Winget check
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "`n❌ Winget not found. Please install App Installer:"
    Write-Host "👉 https://apps.microsoft.com/store/detail/app-installer/9NBLGGH4NNS1"
    exit 1
}

# ─────────────────────────────────────────────────────────────────────────────
# 2. Install Windows Terminal
if (-not (winget list --name "Windows Terminal" | Select-String "Windows Terminal")) {
    Install-App "Microsoft.WindowsTerminal"
} else {
    Write-Host "✅ Windows Terminal already installed."
}

# ─────────────────────────────────────────────────────────────────────────────
# 3. Install PowerShell
if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
    Install-App "Microsoft.PowerShell"
} else {
    Write-Host "✅ PowerShell already installed."
}

# ─────────────────────────────────────────────────────────────────────────────
# 4. Install Oh-My-Posh
if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Install-App "JanDeDobbeleer.OhMyPosh"
} else {
    Write-Host "✅ Oh-My-Posh already installed."
}

# ─────────────────────────────────────────────────────────────────────────────
# 5. Install Terminal Icons
if (-not (Get-Module -ListAvailable Terminal-Icons)) {
    Write-Host "`n📦 Installing Terminal-Icons..."
    Install-Module -Name Terminal-Icons -Repository PSGallery -Force
    Import-Module Terminal-Icons
} else {
    Write-Host "✅ Terminal-Icons already installed."
}

# ─────────────────────────────────────────────────────────────────────────────
# 6. Install Fonts
$fontSource = "$PSScriptRoot\fonts"
$fontList = @(
    "FiraCode-Regular.ttf",
    "Hack-Regular.ttf"
)

foreach ($font in $fontList) {
    $path = Join-Path $fontSource $font
    if (Test-Path $path) {
        Write-Host "`n🖋 Installing font: $font"
        Copy-Item $path -Destination "$env:WINDIR\Fonts" -Force
        Start-Process -FilePath $path -Verb install
    } else {
        Write-Host "⚠️ Font not found: $font"
    }
}

# ─────────────────────────────────────────────────────────────────────────────
# 7. Apply your PowerShell profile
$repoProfile = "$PSScriptRoot\powershell\Microsoft.PowerShell_profile.ps1"
$userProfile = $PROFILE

Write-Host "`n🔧 Copying your PowerShell profile..."
if (Test-Path $repoProfile) {
    Copy-Item $repoProfile -Destination $userProfile -Force
    Write-Host "✅ Profile applied to $userProfile"
} else {
    Write-Host "⚠️ Could not find PowerShell profile in: $repoProfile"
}

# ─────────────────────────────────────────────────────────────────────────────
# 8. Apply Windows Terminal settings
$repoSettings = "$PSScriptRoot\terminal\settings.json"
$wtSettingsTarget = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

Write-Host "`n🖥 Applying Windows Terminal settings..."
if (Test-Path $repoSettings) {
    Copy-Item $repoSettings -Destination $wtSettingsTarget -Force
    Write-Host "✅ settings.json applied to Windows Terminal."
} else {
    Write-Host "⚠️ Could not find terminal/settings.json in repo."
}

# ─────────────────────────────────────────────────────────────────────────────
# 9. Install Neovim (if missing) and sync config
if (-not (Get-Command nvim -ErrorAction SilentlyContinue)) {
    Write-Host "`n📦 Neovim not found — installing..."
    Install-App "Neovim.Neovim"
} else {
    Write-Host "✅ Neovim already installed."
}

$nvimSource = "$PSScriptRoot\nvim"
$nvimTarget = "$env:LOCALAPPDATA\nvim"

Write-Host "`n📁 Syncing Neovim config..."
if (Test-Path $nvimSource) {
    Copy-Item $nvimSource -Destination $nvimTarget -Recurse -Force
    Write-Host "✅ Neovim config installed to: $nvimTarget"
} else {
    Write-Host "⚠️ Neovim config folder not found at: $nvimSource"
}

# ─────────────────────────────────────────────────────────────────────────────
# 10. Install Visual Studio Code
if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Install-App "Microsoft.VisualStudioCode"
} else {
    Write-Host "✅ Visual Studio Code already installed."
}

# ─────────────────────────────────────────────────────────────────────────────
# 11. Apply VS Code settings + keybindings
$vsCodeSource = "$PSScriptRoot\vscode-config"
$vsUserSettings = "$env:APPDATA\Code\User"

Write-Host "`n🛠️  Applying VS Code settings..."
if (Test-Path "$vsCodeSource\settings.json") {
    Copy-Item "$vsCodeSource\settings.json" "$vsUserSettings\settings.json" -Force
    Write-Host "✅ settings.json applied."
} else {
    Write-Host "⚠️ settings.json not found in vscode-config."
}

if (Test-Path "$vsCodeSource\keybindings.json") {
    Copy-Item "$vsCodeSource\keybindings.json" "$vsUserSettings\keybindings.json" -Force
    Write-Host "✅ keybindings.json applied."
} else {
    Write-Host "⚠️ keybindings.json not found in vscode-config."
}

# ─────────────────────────────────────────────────────────────────────────────
# 12. Install VS Code extensions
if (Test-Path "$vsCodeSource\extensions.txt") {
    $extensions = Get-Content "$vsCodeSource\extensions.txt"
    foreach ($ext in $extensions) {
        code --install-extension $ext
    }
    Write-Host "✅ VS Code extensions installed."
} else {
    Write-Host "⚠️ extensions.txt not found in vscode-config."
}

# ─────────────────────────────────────────────────────────────────────────────
# 13. Install Essential Developer Tools
$devTools = @(
    "Git.Git",
    "OpenJS.NodeJS.LTS",
    "Python.Python.3",
    "7zip.7zip",
    "BurntSushi.ripgrep",
    "sharkdp.fd",
    "casey.just"
)

Write-Host "`n🧰 Installing essential developer tools..."
foreach ($tool in $devTools) {
    Install-App $tool
}
Write-Host "✅ Dev tools installation complete."

# ─────────────────────────────────────────────────────────────────────────────
# 14. (Optional) chezmoi
# if (-not (Get-Command chezmoi -ErrorAction SilentlyContinue)) {
#     Write-Host "`n📦 Installing chezmoi..."
#     Invoke-WebRequest -Uri https://get.chezmoi.io/ps1 -UseBasicParsing | Invoke-Expression
# }
# Write-Host "`n🚀 Applying chezmoi dotfiles..."
# chezmoi init yourusername --ssh
# chezmoi apply

# ─────────────────────────────────────────────────────────────────────────────
# 15. Summary Log

Write-Host "`n📋 SUMMARY"
Write-Host "────────────────────────────────────────────"
Write-Host "✔ PowerShell profile: $userProfile"
Write-Host "✔ Windows Terminal settings: $wtSettingsTarget"
Write-Host "✔ VS Code settings: $vsUserSettings\settings.json"
Write-Host "✔ VS Code keybindings: $vsUserSettings\keybindings.json"
Write-Host "✔ Fonts installed: $($fontList -join ', ')"
Write-Host "✔ Neovim config: $nvimTarget"
Write-Host "✔ Dev tools installed: Git, Node.js, Python, Neovim, ripgrep, fd, 7zip"
Write-Host "✔ Date completed: $(Get-Date)"
Write-Host "────────────────────────────────────────────"

Write-Host "`n🎉 All done! Restart your terminal to see your theme, aliases, and config in action."
