. "$PSScriptRoot\_lib.ps1"

$repoSettings = Join-Path $PSScriptRoot "..\windows\terminal\settings.json"
$wtSettingsTarget = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

if (-not (Test-Path $repoSettings)) {
    Log-Warn "Terminal settings not found at: $repoSettings"
    exit 0
}

# If Windows Terminal isn't installed, copying may still create the folder but won't be used.
# So we warn.
if (-not (Test-Path (Split-Path $wtSettingsTarget))) {
    Log-Warn "Windows Terminal settings folder not found. Install Windows Terminal first (just apps)."
}

Log-Info "Applying Windows Terminal settings..."
Copy-File $repoSettings $wtSettingsTarget
Log-Info "Windows Terminal settings applied."
