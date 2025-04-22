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
Set-Alias ls Get-ChildItem
Set-Alias ll "Get-ChildItem -Force -l"
Set-Alias la "Get-ChildItem -Force -a"
Set-Alias cat Get-Content
Set-Alias rm Remove-Item
Set-Alias mv Move-Item
Set-Alias cp Copy-Item
Set-Alias pwd Get-Location
Set-Alias clear Clear-Host

# Archive helper
Set-Alias xzip Expand-Archive
Set-Alias mkzip Compress-Archive

# Editor
Set-Alias vim nvim
Set-Alias vi nvim

# Git shortcuts
Set-Alias gs git status
Set-Alias ga git add
Set-Alias gc git commit
Set-Alias gp git push
Set-Alias gl git log
Set-Alias gd git diff
Set-Alias gb git branch
Set-Alias gco git checkout
Set-Alias gst git stash
Set-Alias gr git remote
