# --- History & Logic ---
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000
setopt extendedglob nomatch notify
bindkey -v

# --- FZF Configuration ---
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --inline-info"

# --- Plugins (Order Matters) ---
[ -f ~/.zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f ~/.zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ~/.zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f ~/.zsh-plugins/fzf-tab/fzf-tab.plugin.zsh ] && source ~/.zsh-plugins/fzf-tab/fzf-tab.plugin.zsh

# --- Completion Settings ---
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
zmodload zsh/complist

# --- fzf-tab tweaks ---
zstyle ':fzf-tab:*' fzf-command fzf
zstyle ':fzf-tab:*' fzf-pad 4
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

# --- Aliases ---
alias vim='nvim'
alias vi='nvim'
alias cat='batcat'
alias fd='fdfind'
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --group-directories-first'
alias la='eza -a --icons --group-directories-first'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gst='git stash'
alias gr='git remote'

# --- Environment Variables ---
export VISUAL=nvim
export EDITOR="$VISUAL"

# --- System Paths ---
# Ensure local bin (for fd/bat symlinks) and snap bin (for Neovim) are prioritized properly
export PATH="$HOME/.local/bin:$PATH"
path+=('/snap/bin')
export PATH

# --- fnm ---
export FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell zsh)"
fi

# --- Starship ---
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
