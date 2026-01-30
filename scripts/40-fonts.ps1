. "$PSScriptRoot\_lib.ps1"

$fontSource = Join-Path $PSScriptRoot "..\fonts"

$fontMap = @{
    "FiraCode-Regular.ttf" = "FiraCode Nerd Font Mono"
    "Hack-Regular.ttf"     = "Hack Nerd Font Mono"
}

if (-not (Test-Path $fontSource)) {
    Log-Warn "Fonts folder not found at: $fontSource"
    exit 0
}

if (-not (Test-IsAdmin)) {
    Log-Warn "Not running as Administrator. Skipping font install (requires admin)."
    exit 0
}

$installed = New-Object System.Collections.Generic.List[string]

foreach ($fontFile in $fontMap.Keys) {
    $fontPath = Join-Path $fontSource $fontFile
    if (-not (Test-Path $fontPath)) {
        Log-Warn "Font file not found: $fontPath"
        continue
    }

    $fontDest = Join-Path "$env:WINDIR\Fonts" $fontFile
    $fontName = $fontMap[$fontFile]

    Log-Info "Installing font: $fontFile"
    Copy-Item $fontPath -Destination $fontDest -Force

    New-ItemProperty `
        -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" `
        -Name "$fontName (TrueType)" `
        -Value $fontFile `
        -PropertyType String `
        -Force | Out-Null

    $installed.Add($fontName)
    Log-Info "Installed font: $fontName"
}

if ($installed.Count -gt 0) {
    Log-Info ("Fonts installed: " + ($installed -join ", "))
} else {
    Log-Info "No fonts were installed."
}
