# --- History & Logic ---
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000

setopt extendedglob nomatch notify
setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history

bindkey -v

# --- System Paths / Tool Activation ---
typeset -U path PATH
export PATH="$HOME/.local/bin:$PATH"
[ -x "$HOME/.local/bin/mise" ] && eval "$($HOME/.local/bin/mise activate zsh)"

# --- FZF Configuration ---
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --inline-info"

# --- Completion Settings ---
mkdir -p ~/.cache
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*' cache-path ~/.cache/zcompcache
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
zmodload zsh/complist

# --- Plugins ---
[ -f ~/.zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f ~/.zsh-plugins/fzf-tab/fzf-tab.plugin.zsh ] && source ~/.zsh-plugins/fzf-tab/fzf-tab.plugin.zsh

# --- fzf-tab tweaks ---
zstyle ':fzf-tab:*' fzf-command fzf
zstyle ':fzf-tab:*' fzf-pad 4
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'command -v eza >/dev/null && eza -1 --color=always $realpath || ls -1 $realpath'

# --- Aliases ---
alias vim='nvim'
alias vi='nvim'
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
alias gcl='git clone'
alias grs='git reset'

# --- Environment Variables ---
export VISUAL=nvim
export EDITOR="$VISUAL"

# --- SSH Agent ---
if [ -f "$HOME/.ssh/id_ed25519" ] && command -v ssh-agent >/dev/null 2>&1 && command -v ssh-add >/dev/null 2>&1; then
  if [ -z "${SSH_AUTH_SOCK:-}" ] || [ ! -S "${SSH_AUTH_SOCK:-}" ]; then
    eval "$(ssh-agent -s)" >/dev/null
  fi

  ssh-add "$HOME/.ssh/id_ed25519" </dev/null 2>/dev/null || true
fi

# --- Starship ---
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# --- Syntax Highlighting (keep last) ---
[ -f ~/.zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ~/.zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
