. "$PSScriptRoot\_lib.ps1"

Log-Info "Checking winget..."

if (Get-Command winget -ErrorAction SilentlyContinue) {
    Log-Info "winget is available."
    exit 0
}

Log-Warn "winget not found."
Log-Info "Open Microsoft Store -> install App Installer (ProductId: 9NBLGGH4NNS1)."

try {
    Start-Process "ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1"
}
catch {
    Log-Warn "Could not open Microsoft Store automatically."
}

Log-Info "Press Enter once App Installer has finished installing..."
[void][System.Console]::ReadLine()

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Log-Error "winget still not available."
    exit 1
}

Log-Info "winget is now available."
