. "$PSScriptRoot\_lib.ps1"

if (-not (Assert-Command winget "Run: just bootstrap")) { exit 1 }

Log-Info "Installing / Updating commonly used apps and developer tools..."

# Apps you had (and a couple you referenced)
$apps = @(
     "Microsoft.WindowsTerminal",
    "Microsoft.VisualStudioCode",
    "JanDeDobbeleer.OhMyPosh",
    "Neovim.Neovim",

    # Browser / VPN / focus
    "Google.Chrome",
    "Proton.ProtonVPN",
    "Proton.ProtonPass",
    "ColdTurkeySoftware.ColdTurkeyBlocker",
    "Figma.Figma",

    # Dev tools
    "Git.Git",
    "OpenJS.NodeJS.LTS",
    "Python.Python.3.13",
    "7zip.7zip",
    "BurntSushi.ripgrep.GNU",
    "sharkdp.fd",
    "pnpm.pnpm"
)

foreach ($id in $apps) {
    Ensure-App $id
}

Log-Info "Apps/tools installation complete."
