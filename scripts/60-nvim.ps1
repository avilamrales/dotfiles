. "$PSScriptRoot\_lib.ps1"

$nvimSource = Join-Path $PSScriptRoot "..\nvim"
$nvimTarget = Join-Path $env:LOCALAPPDATA "nvim"

if (-not (Test-Path $nvimSource)) {
    Log-Warn "Neovim config folder not found at: $nvimSource"
    exit 0
}

if (-not (Get-Command nvim -ErrorAction SilentlyContinue)) {
    Log-Warn "nvim not found. Install it first (just apps)."
    # Still copy config so it's ready when you install nvim
}

Log-Info "Syncing Neovim config..."
# Copy to target (replaces existing)
if (Test-Path $nvimTarget) {
    Remove-Item -Recurse -Force $nvimTarget
}
Copy-Dir $nvimSource $nvimTarget
Log-Info "Neovim config installed to: $nvimTarget"

# Optional plugin sync if nvim exists
if (Get-Command nvim -ErrorAction SilentlyContinue) {
    try {
        Log-Info "Running Neovim plugin sync (Lazy)..."
        nvim --headless "Lazy! sync" +qall
        Log-Info "Neovim plugin sync complete."
    }
    catch {
        Log-Warn "Neovim plugin sync failed. $($_.Exception.Message)"
    }
}
