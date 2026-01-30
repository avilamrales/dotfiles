. "$PSScriptRoot\_lib.ps1"

$vsCodeSource = Join-Path $PSScriptRoot "..\nvim\vscode-config"
$vsUserSettings = Join-Path $env:APPDATA "Code\User"

if (-not (Test-Path $vsCodeSource)) {
    Log-Warn "VS Code config source not found at: $vsCodeSource"
    exit 0
}

Ensure-Dir $vsUserSettings

# settings.json
$settingsSrc = Join-Path $vsCodeSource "settings.json"
$settingsDst = Join-Path $vsUserSettings "settings.json"
if (Test-Path $settingsSrc) {
    Log-Info "Applying VS Code settings.json..."
    Copy-File $settingsSrc $settingsDst
} else {
    Log-Warn "settings.json not found at: $settingsSrc"
}

# keybindings.json
$keybindingsSrc = Join-Path $vsCodeSource "keybindings.json"
$keybindingsDst = Join-Path $vsUserSettings "keybindings.json"
if (Test-Path $keybindingsSrc) {
    Log-Info "Applying VS Code keybindings.json..."
    Copy-File $keybindingsSrc $keybindingsDst
} else {
    Log-Warn "keybindings.json not found at: $keybindingsSrc"
}

# extensions
$extFile = Join-Path $vsCodeSource "extensions.txt"
if (-not (Test-Path $extFile)) {
    Log-Warn "extensions.txt not found at: $extFile"
    exit 0
}

if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Log-Warn "VS Code 'code' command not found. Install VS Code first (just apps)."
    exit 0
}

Log-Info "Installing VS Code extensions..."
$extensions = Get-Content $extFile | Where-Object { $_ -and $_.Trim().Length -gt 0 }

foreach ($ext in $extensions) {
    Log-Info "Installing extension: $ext"
    try {
        code --install-extension $ext | Out-Null
    }
    catch {
        Log-Warn "Failed to install extension: $ext"
    }
}

Log-Info "VS Code configuration complete."
