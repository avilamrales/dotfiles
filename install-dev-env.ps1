# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃  Dotfiles Bootstrap (PowerShell/Win)  ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# ─────────────────────────────────────────────────────────────────────────────
# Ensure emoji and font icons render correctly
try {
    chcp 65001
}
catch {
    Write-Host @"
❌ Failed to set UTF-8 code page: $($_.Exception.Message)
"@
}
try {
    [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
}
catch {
    Write-Host @"
❌ Failed to set console output encoding: $($_.Exception.Message)
"@
}

# ─────────────────────────────────────────────────────────────────────────────
# Set the error action preference to stop on errors
$ErrorActionPreference = "Stop"

# ─────────────────────────────────────────────────────────────────────────────
# Define a helper function to install apps via winget with auto-accept
function Install-App($id) {
    Write-Host @"
📦 Installing $id...
"@
    try {
        winget install --id $id -e --accept-package-agreements --accept-source-agreements
        Write-Host @"
✅ Successfully installed $id.
"@
    }
    catch {
        Write-Host @"
❌ Failed to install $id.
$($_.Exception.Message)
"@
    }
}

# ─────────────────────────────────────────────────────────────────────────────
# Detect shell in use
Write-Host @"

🔍 Detecting current shell...
"@
$shell = $PSVersionTable.PSEdition

if ($shell -eq "Core") {
    Write-Host @"
✅ Using PowerShell Core (pwsh).
"@
}
elseif ($shell -eq "Desktop") {
    Write-Host @"
✅ Using Windows PowerShell (legacy).
"@
}
else {
    Write-Host @"
⚠️ Unknown shell. This script is built for PowerShell.
"@
    exit 1
}

# ─────────────────────────────────────────────────────────────────────────────
# 1. Winget check
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host @"
❌ Winget not found. Attempting to open Microsoft Store...
"@

    try {
        Write-Host @"
🛠 Before we continue...

If Microsoft Store asks you to update **before installing anything**, please:
1. Let it fully update.
2. Close this script.
3. Re-run it after the update is complete.

This is necessary because App Installer might not be visible until after updating.

⏸ Press Enter to continue when you're ready...
"@

        [void][System.Console]::ReadLine()

        Start-Process "ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1"
        Write-Host @"

📦 Please install App Installer from the Store window that opened.
"@
    }
    catch {
        Write-Host @"
❌ Could not open Microsoft Store automatically.

Please install App Installer manually from this URL:
👉 https://apps.microsoft.com/store/detail/app-installer/9NBLGGH4NNS1
"@
    }

    Write-Host @"

⏸ Press Enter once App Installer has finished installing...
"@
    [void][System.Console]::ReadLine()

    # Recheck if winget is now available
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host @"

❌ Winget still not available. Exiting script.
"@
        exit 1
    }

    Write-Host @"

✅ Winget is now available. Continuing setup...
"@
}


# ─────────────────────────────────────────────────────────────────────────────
# 2. Install Windows Terminal
$wingetTerminal = $null
try {
    $wingetTerminal = winget list --id Microsoft.WindowsTerminal --source winget 2>&1 | Out-String
}
catch {
    Write-Host @"
❌ Failed to check Windows Terminal installation: $($_.Exception.Message)
"@
}
if ($wingetTerminal -notmatch "Windows Terminal") {
    Install-App "Microsoft.WindowsTerminal"
}
else {
    Write-Host @"
✅ Windows Terminal already installed.
"@
}

# ─────────────────────────────────────────────────────────────────────────────
# 3. Install PowerShell
if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
    Install-App "Microsoft.PowerShell"
}
else {
    Write-Host @"
✅ PowerShell already installed.
"@
}

# ─────────────────────────────────────────────────────────────────────────────
# 4. Install Oh-My-Posh
if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Install-App "JanDeDobbeleer.OhMyPosh"
}
else {
    Write-Host @"
✅ Oh-My-Posh already installed.
"@
}

# ─────────────────────────────────────────────────────────────────────────────
# 5. Install Terminal Icons
if (-not (Get-Module -ListAvailable Terminal-Icons)) {
    Write-Host @"

📦 Installing Terminal-Icons...
"@
    try {
        Install-Module -Name Terminal-Icons -Repository PSGallery -Force
    }
    catch {
        Write-Host @"
❌ Failed to install Terminal-Icons module: $($_.Exception.Message)
"@
    }
    Import-Module Terminal-Icons
}
else {
    Write-Host @"
✅ Terminal-Icons already installed.
"@
}

# ─────────────────────────────────────────────────────────────────────────────
# 6. Install Fonts
$fontSource = "$PSScriptRoot\fonts\"

# Map font file names to their internal font names
$fontMap = @{
    "FiraCode-Regular.ttf" = "FiraCode Nerd Font Mono"
    "Hack-Regular.ttf"     = "Hack Nerd Font Mono"
}

foreach ($fontFile in $fontMap.Keys) {
    $fontPath = Join-Path $fontSource $fontFile
    $fontDest = Join-Path "$env:WINDIR\Fonts\" $fontFile
    $fontName = $fontMap[$fontFile]

    if (Test-Path $fontPath) {
        Write-Host @"

🖋 Installing font: $fontFile
"@

        try {
            Copy-Item $fontPath -Destination $fontDest -Force
            Write-Host @"
✅ Copied $fontFile to Fonts folder
"@
        }
        catch {
            Write-Host @"
❌ Failed to copy ${fontFile}: $($_.Exception.Message)
"@
            continue
        }

        try {
            New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "$fontName (TrueType)" -Value $fontFile -PropertyType String -Force | Out-Null
            Write-Host @"
✅ Registered $fontName in the registry
"@
        }
        catch {
            Write-Host @"
❌ Failed to register ${fontFile}: $($_.Exception.Message)
"@
        }

    }
    else {
        Write-Host @"
⚠️ Font not found: $fontFile
"@
    }
}

# ─────────────────────────────────────────────────────────────────────────────
# 7. Apply your PowerShell profile
$repoProfile = "$PSScriptRoot\windows\powershell\Microsoft.PowerShell_profile.ps1"
$userProfile = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

Write-Host @"

🔧 Copying your PowerShell profile...
"@

# Ensure the destination folder exists
$profileDir = Split-Path $userProfile
New-Item -ItemType Directory -Path $profileDir -Force | Out-Null

if (Test-Path $repoProfile) {
    Copy-Item $repoProfile -Destination $userProfile -Force
    Write-Host @"
✅ Profile applied to $userProfile
"@
}
else {
    Write-Host @"
⚠️ Could not find PowerShell profile in: $repoProfile
"@
}

# 🧼 Unblock PowerShell profile (remove web download flag)
if (Test-Path $userProfile) {
    Unblock-File -Path $userProfile
    Write-Host @"
🔓 Unblocked execution restriction on PowerShell profile.
"@
}

# ─────────────────────────────────────────────────────────────────────────────
# 8. Apply Windows Terminal settings
$repoSettings = "$PSScriptRoot\windows\terminal\settings.json"
$wtSettingsTarget = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

Write-Host @"

🖥 Applying Windows Terminal settings...
"@
if (Test-Path $repoSettings) {
    Copy-Item $repoSettings -Destination $wtSettingsTarget -Force
    Write-Host @"
✅ settings.json applied to Windows Terminal.
"@
}
else {
    Write-Host @"
⚠️ Could not find terminal/settings.json in: $repoSettings
"@
}

# ─────────────────────────────────────────────────────────────────────────────
# 9. Install Neovim (if missing) and sync config
if (-not (Get-Command nvim -ErrorAction SilentlyContinue)) {
    Write-Host @"

📦 Neovim not found — installing...
"@
    Install-App "Neovim.Neovim"
}
else {
    Write-Host @"
✅ Neovim already installed.
"@
}

$nvimSource = "$PSScriptRoot\nvim"
$nvimTarget = "$env:LOCALAPPDATA\nvim"

Write-Host @"

📁 Syncing Neovim config...
"@
if (Test-Path $nvimSource) {
    Copy-Item $nvimSource -Destination $nvimTarget -Recurse -Force
    Write-Host @"
✅ Neovim config installed to: $nvimTarget
"@
}
else {
    Write-Host @"
⚠️ Neovim config folder not found at: $nvimSource
"@
}

# ─────────────────────────────────────────────────────────────────────────────
# 10. Install Visual Studio Code
if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Install-App "Microsoft.VisualStudioCode"
}
else {
    Write-Host @"
✅ Visual Studio Code already installed.
"@
}

# ─────────────────────────────────────────────────────────────────────────────
# 11. Apply VS Code settings + keybindings
$vsCodeSource = "$PSScriptRoot\nvim\vscode-config"
$vsUserSettings = "$env:APPDATA\Code\User"

Write-Host @"
🛠️ Applying VS Code settings...
"@

# Ensure destination directory exists
New-Item -ItemType Directory -Path $vsUserSettings -Force | Out-Null

# Copy settings.json
if (Test-Path "$vsCodeSource\settings.json") {
    Copy-Item "$vsCodeSource\settings.json" "$vsUserSettings\settings.json" -Force
    Write-Host @"
✅ settings.json applied.
"@
}
else {
    Write-Host @"
⚠️ settings.json not found in vscode-config.
"@
}

# Copy keybindings.json
if (Test-Path "$vsCodeSource\keybindings.json") {
    Copy-Item "$vsCodeSource\keybindings.json" "$vsUserSettings\keybindings.json" -Force
    Write-Host @"
✅ keybindings.json applied.
"@
}
else {
    Write-Host @"
⚠️ keybindings.json not found in vscode-config.
"@
}

# ─────────────────────────────────────────────────────────────────────────────
# 12. Install VS Code extensions
if (Test-Path "$vsCodeSource\extensions.txt") {
    $extensions = Get-Content "$vsCodeSource\extensions.txt"
    foreach ($ext in $extensions) {
        Write-Host @"
📦 Installing VS Code extension: $ext
"@
        try {
            code --install-extension $ext -ErrorAction Stop
        }
        catch {
            Write-Host @"
⚠️ Failed to install $ext
"@
        } 
    }
    Write-Host @"
✅ VS Code extensions installed.
"@
}
else {
    Write-Host @"
⚠️ extensions.txt not found in vscode-config.
"@
}


# ─────────────────────────────────────────────────────────────────────────────
# 13. Install Essential Developer Tools
$devTools = @(
    "Git.Git",
    "OpenJS.NodeJS.LTS",
    "Python.Python.3.13",
    "7zip.7zip",
    "BurntSushi.ripgrep.GNU",
    "sharkdp.fd",
    "Casey.Just"
)

Write-Host @"

🧰 Installing essential developer tools...
"@
foreach ($tool in $devTools) {
    Install-App $tool
}
Write-Host @"
✅ Dev tools installation complete.
"@

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

Write-Host @"

📋 SUMMARY
────────────────────────────────────────────
✔ PowerShell profile: $userProfile
✔ Windows Terminal settings: $wtSettingsTarget
✔ VS Code settings: $vsUserSettings\settings.json
✔ VS Code keybindings: $vsUserSettings\keybindings.json
✔ Fonts installed: $($fontList -join ', ')
✔ Neovim config: $nvimTarget
✔ Dev tools installed: Git, Node.js, Python, Neovim, ripgrep, fd, 7zip
✔ Date completed: $(Get-Date)
────────────────────────────────────────────

🎉 All done! Restart your terminal to see your theme, aliases, and config in action.
"@
