Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Log-Info([string]$Message) { Write-Host "- $Message" }
function Log-Warn([string]$Message) { Write-Host "-- WARNING: $Message" }
function Log-Error([string]$Message) { Write-Host "--- ERROR: $Message" }

function Test-IsAdmin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $p  = New-Object Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Assert-Command([string]$Name, [string]$Hint) {
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        Log-Warn "$Name not found. $Hint"
        return $false
    }
    return $true
}

function Invoke-Winget {
    param(
        [Parameter(Mandatory)][string[]] $Args
    )

    # Capture output + exit code (winget doesn't throw PowerShell exceptions)
    $out = & winget @Args 2>&1 | Out-String
    $code = $LASTEXITCODE

    return [pscustomobject]@{
        Code = $code
        Out  = $out
    }
}

$WINGET_OK_CODES = @(0, -1978335189, -1978335153)

function Install-App([string]$Id) {
    Log-Info "Installing $Id..."

    $r = Invoke-Winget -Args @(
        "install", "--id", $Id, "-e",
        "--accept-package-agreements", "--accept-source-agreements", "--disable-interactivity"
    )

    if ($r.Code -in $WINGET_OK_CODES) {
        Log-Info "$Id installed / already present."
        return
    }

    Log-Error "Install failed for $Id. exit=$($r.Code)`n$($r.Out)"
    return
}

function Update-App([string]$Id) {
    Log-Info "Updating $Id..."

    $r = Invoke-Winget -Args @(
        "upgrade", "--id", $Id, "-e",
        "--accept-package-agreements", "--accept-source-agreements", "--disable-interactivity"
    )

    if ($r.Code -eq 0) {
        Log-Info "$Id upgraded."
        return [pscustomobject]@{ Status = "Upgraded"; Ok = $true }
    }

    # If already latest / not applicable, treat as success
    if ($r.Code -in $WINGET_OK_CODES) {
        Log-Info "$Id already up to date."
        return [pscustomobject]@{ Status = "UpToDate"; Ok = $true }
    }

    # Detect the specific "not installed" case from output
    # (winget wording varies a bit; these cover the common ones)
    if ($r.Out -match "(?i)No installed package found|No package found matching input criteria|is not installed|No installed package") {
        Log-Info "$Id not installed."
        return [pscustomobject]@{ Status = "NotInstalled"; Ok = $false }
    }

    # Real failure
    Log-Error "Upgrade failed for $Id. exit=$($r.Code)`n$($r.Out)"
    return [pscustomobject]@{ Status = "Failed"; Ok = $false }
}

function Ensure-App([string]$Id) {
    $u = Update-App $Id

    if ($u.Ok) {
        return
    }

    if ($u.Status -eq "NotInstalled") {
        return (Install-App $Id)
    }

    return
}

function Ensure-Dir([string]$Path) {
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
}

function Copy-File([string]$Source, [string]$Dest) {
    Ensure-Dir (Split-Path $Dest)
    Copy-Item $Source -Destination $Dest -Force
}

function Copy-Dir([string]$SourceDir, [string]$DestDir) {
    Ensure-Dir $DestDir
    Copy-Item $SourceDir -Destination $DestDir -Recurse -Force
}
