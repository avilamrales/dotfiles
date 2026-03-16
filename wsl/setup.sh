#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${HOME}/dotfiles"
WSL_DIR="${DOTFILES_DIR}/wsl"
NVIM_DIR="${DOTFILES_DIR}/nvim"

DISABLE_SYSTEMD=true

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script finishes
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

while [[ "$#" -gt 0 ]]; do
  case $1 in
  --enable-systemd) DISABLE_SYSTEMD=false ;;
  *)
    echo "Unknown parameter passed: $1"
    exit 1
    ;;
  esac
  shift
done

log() {
  printf "\n==> %s\n" "$1"
}

backup_path() {
  local target="$1"
  local source="${2:-}"

  if [[ -L "$target" && -n "$source" ]]; then
    local current
    current="$(readlink -f "$target" || true)"
    local desired
    desired="$(readlink -f "$source" || true)"
    if [[ "$current" == "$desired" ]]; then
      return 0
    fi
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    mv "$target" "${target}.bak.$(date +%Y%m%d-%H%M%S)"
  fi
}

# Silence login message
log "Silencing login message"
touch "$HOME/.hushlogin"

# Update and Upgrade System
log "Updating and upgrading apt"
sudo apt update
sudo apt upgrade -y

# Disable systemd
if [ "$DISABLE_SYSTEMD" = true ]; then
  log "Disabling systemd in wsl.conf"
  if sudo grep -q "systemd=true" /etc/wsl.conf 2>/dev/null; then
    sudo sed -i 's/systemd=true/systemd=false/' /etc/wsl.conf
  elif ! sudo grep -q "systemd=false" /etc/wsl.conf 2>/dev/null; then
    echo -e "\n[boot]\nsystemd=false" | sudo tee -a /etc/wsl.conf >/dev/null
  fi
fi

# Install core system tools
log "Installing core system dependencies"
sudo apt install -y \
  build-essential \
  git \
  curl \
  unzip \
  wget \
  zsh \
  gpg \
  openssh-client \
  inotify-tools \
  xclip

# Set zsh as the default shell
log "Setting zsh as default shell"
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v zsh)" ]; then
  sudo chsh -s "$(command -v zsh)" "$USER"
fi

# Setup Mise
log "Installing mise"
if ! command -v mise >/dev/null 2>&1; then
  curl -fsSL https://mise.run | sh
fi
export PATH="$HOME/.local/bin:$PATH"
eval "$(mise activate bash)"

# Install high-level tools via mise
log "Installing all tools via mise"
# Runtimes & Editor
mise use --global node@lts
mise use --global bun@latest
mise use --global neovim@stable

# CLI tools (Latest versions)
mise use --global usage
mise use --global fzf@latest
mise use --global ripgrep@latest
mise use --global lazygit@latest
mise use --global fd@latest
mise use --global bat@latest
mise use --global eza@latest
mise use --global starship@latest

# Create the necessary directories for setup
log "Creating directories"
mkdir -p "$HOME/.config" "$HOME/.zsh-plugins"

# Install zsh plugins
log "Installing zsh plugins"
[[ ! -d "$HOME/.zsh-plugins/zsh-autosuggestions" ]] && git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh-plugins/zsh-autosuggestions"
[[ ! -d "$HOME/.zsh-plugins/zsh-syntax-highlighting" ]] && git clone https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.zsh-plugins/zsh-syntax-highlighting"
[[ ! -d "$HOME/.zsh-plugins/fzf-tab" ]] && git clone https://github.com/Aloxaf/fzf-tab "$HOME/.zsh-plugins/fzf-tab"

# Link shell config to the dotfiles config
log "Linking shell config"
backup_path "$HOME/.zshrc"
ln -sfn "$WSL_DIR/.zshrc" "$HOME/.zshrc"

backup_path "$HOME/.config/starship.toml"
ln -sfn "$WSL_DIR/starship.toml" "$HOME/.config/starship.toml"

# config neovim
log "Linking Neovim config"
backup_path "$HOME/.config/nvim"
ln -sfn "$NVIM_DIR" "$HOME/.config/nvim"

log "Done! Run: exec zsh"
