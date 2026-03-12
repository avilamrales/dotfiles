. "$PSScriptRoot\_lib.ps1"

if (-not (Assert-Command winget "Run: just bootstrap")) { exit 1 }

Log-Info "Installing / Updating commonly used apps and developer tools..."

# Apps you had (and a couple you referenced)
$apps = @(
     "Microsoft.WindowsTerminal",
    "Microsoft.VisualStudioCode",
    "JanDeDobbeleer.OhMyPosh"
)

foreach ($id in $apps) {
    Ensure-App $id
}

Log-Info "Apps/tools installation complete."
