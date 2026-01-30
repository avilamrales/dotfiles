param(
    [switch]$Relaunched
)

. "$PSScriptRoot\_lib.ps1"

# Make console output UTF-8 (no emojis, but keeps things consistent)
try { chcp 65001 | Out-Null } catch {}
try { [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding } catch {}

function Test-IsAdmin {
    try {
        $id = [Security.Principal.WindowsIdentity]::GetCurrent()
        $p  = New-Object Security.Principal.WindowsPrincipal($id)
        return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    } catch {
        return $false
    }
}

function Sync-ProcessPath {
    # Refresh PATH in the current process from Machine + User
    $machine = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $user    = [Environment]::GetEnvironmentVariable("Path", "User")

    if ([string]::IsNullOrWhiteSpace($machine)) { $machine = "" }
    if ([string]::IsNullOrWhiteSpace($user)) { $user = "" }

    $env:Path = ($machine.TrimEnd(';') + ";" + $user.TrimStart(';')).Trim(';')

    # Extra safety: ensure pwsh default install path exists in PATH (if installed via MSI)
    $pwshDir = "C:\Program Files\PowerShell\7"
    if (Test-Path (Join-Path $pwshDir "pwsh.exe")) {
        $pathParts = $env:Path -split ';'
        if ($pathParts -notcontains $pwshDir) {
            $env:Path = $env:Path.TrimEnd(';') + ";" + $pwshDir
        }
    }
}

Log-Info "Bootstrap starting (minimal dependencies only)."

$needsRestart = $false

# 1) Ensure winget exists
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Log-Warn "winget not found (yet)."

    Log-Info "Opening Microsoft Store -> App Installer."
    Log-Info "Note: On fresh installs/VMs, the Store sometimes needs 1-3 minutes to detect"
    Log-Info "the App Installer update. If it shows as installed with no updates, wait a bit"
    Log-Info "and refresh the Store (Downloads/Library) until App Installer updates."

    try {
        Start-Process "ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1"
    }
    catch {
        Log-Warn "Could not open Microsoft Store automatically."
        Log-Info "Open Microsoft Store manually and search for 'App Installer' (ProductId: 9NBLGGH4NNS1)."
    }

    Log-Info "After App Installer updates/finishes installing, come back here and press Enter..."
    [void][System.Console]::ReadLine()

    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Log-Error "winget still not available. This is usually Store sync delay."
        Log-Info  "Wait another minute, refresh Store Downloads/Library, then press Enter again."
        exit 1
    }

    $needsRestart = $true
}

Log-Info "winget is available."

# 2) Ensure PowerShell Core (pwsh) exists (needed for your justfile shell)
if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
    Log-Info "Verifying PowerShell installation..."
    Ensure-App "Microsoft.PowerShell"
    $needsRestart = $true
}

# 3) Ensure just exists (required for your task runner)
if (-not (Get-Command just -ErrorAction SilentlyContinue)) {
    Log-Info "Verifying just installation..."
    Ensure-App "Casey.Just"
    $needsRestart = $true
}


# If we installed anything, restart in the SAME window to refresh PATH/environment.
if (-not $Relaunched -and $needsRestart) {
    Log-Info "Refreshing environment (restarting script in the same terminal)..."

    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $PSCommandPath -Relaunched
    exit $LASTEXITCODE
}


# Fresh session: rebuild PATH so newly installed commands are detectable now
Sync-ProcessPath

# Final sanity checks (now they should pass in the fresh session)
if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
    Log-Error "pwsh is still not available after restart. Cannot continue."
    exit 1
}
if (-not (Get-Command just -ErrorAction SilentlyContinue)) {
    Log-Error "just is still not available after restart. Cannot continue."
    exit 1
}

Log-Info "Minimal dependencies ready."
Log-Info "Running: just all"

# Ensure we run just from the repo root (adjust if your justfile lives elsewhere)
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Push-Location $repoRoot
try {
    just all
    exit $LASTEXITCODE
}
finally {
    Pop-Location
}
