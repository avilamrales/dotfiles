# Load Oh My Posh theme
oh-my-posh init pwsh --config "$HOME\dotfiles\oh-my-posh\powerlevel10k.omp.json" | Invoke-Expression

# Import terminal icons
Import-Module -Name Terminal-Icons -ErrorAction SilentlyContinue

# Enable smart prediction
Set-PSReadLineOption -PredictionViewStyle ListView

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ Alias Section             ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Linux-style shell aliases
Set-Alias ll "Get-ChildItem -Force -l"
Set-Alias la "Get-ChildItem -Force -a"

# Archive helper
Set-Alias xzip Expand-Archive
Set-Alias mkzip Compress-Archive

# Editor
Set-Alias vim nvim
Set-Alias vi nvim

# Git shortcuts
function gs { git status }
function ga { git add @args }
function gc { git commit @args }
function gp { git push @args }
function gl { git log @args }
function gd { git diff @args }
function gb { git branch @args }
function gco { git checkout @args }
function gst { git stash @args }
function gr { git remote @args }
