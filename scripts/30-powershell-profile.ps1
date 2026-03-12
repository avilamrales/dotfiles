. "$PSScriptRoot\_lib.ps1"

$repoProfile = Join-Path $PSScriptRoot "..\windows\powershell\Microsoft.PowerShell_profile.ps1"
$userProfile = Join-Path $HOME "Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

if (-not (Test-Path $repoProfile)) {
    Log-Warn "PowerShell profile not found at: $repoProfile"
    exit 0
}

Log-Info "Applying PowerShell profile..."
Copy-File $repoProfile $userProfile

try {
    Unblock-File -Path $userProfile
    Log-Info "Unblocked PowerShell profile."
}
catch {
    Log-Warn "Could not unblock PowerShell profile. $($_.Exception.Message)"
}

# Terminal-Icons module (optional, but you used it)
if (Get-Command pwsh -ErrorAction SilentlyContinue) {
    try {
        if (-not (Get-Module -ListAvailable Terminal-Icons)) {
            Log-Info "Installing Terminal-Icons module..."
            Install-Module -Name Terminal-Icons -Repository PSGallery -Force
        }
        Log-Info "Terminal-Icons ready."
    }
    catch {
        Log-Warn "Terminal-Icons install failed. $($_.Exception.Message)"
    }
}

Log-Info "PowerShell profile applied to: $userProfile"
