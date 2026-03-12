. "$PSScriptRoot\_lib.ps1"

$vsCodeSource = Join-Path $PSScriptRoot "..\vscode"

if (-not (Test-Path $vsCodeSource)) {
    Log-Warn "VS Code config source not found at: $vsCodeSource"
    exit 0
}

# extensions
$extFile = Join-Path $vsCodeSource "windows-extensions.txt"
if (-not (Test-Path $extFile)) {
    Log-Warn "windows-extensions.txt not found at: $extFile"
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
