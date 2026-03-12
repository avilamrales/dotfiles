#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${HOME}/dotfiles"
WSL_DIR="${DOTFILES_DIR}/wsl"
VSCODE_DIR="${DOTFILES_DIR}/vscode"
NVIM_DIR="${DOTFILES_DIR}/nvim"

log() {
  printf "\n==> %s\n" "$1"
}

ensure_line() {
  local line="$1"
  local file="$2"
  grep -Fqx "$line" "$file" 2>/dev/null || echo "$line" >> "$file"
}

log "Updating apt"
sudo apt update
sudo apt upgrade -y

log "Installing base packages"
sudo apt install -y \
  build-essential \
  git \
  curl \
  unzip \
  wget \
  zsh \
  ripgrep \
  fd-find \
  fzf \
  bat \
  eza \
  gpg

log "Creating symlinks for Ubuntu-renamed packages (bat and fd)"
mkdir -p "$HOME/.local/bin"

if command -v batcat >/dev/null 2>&1; then
  ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
fi

if command -v fdfind >/dev/null 2>&1; then
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi

log "Installing Neovim via Snap (for v0.10+)"
sudo snap install nvim --classic

log "Setting zsh as default shell"
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)"
fi

log "Creating directories"
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.zsh-plugins"
mkdir -p "$HOME/.vscode-server/data/Machine"

log "Installing fnm if missing"
if [ ! -d "$HOME/.local/share/fnm" ]; then
  curl -fsSL https://fnm.vercel.app/install | bash
fi

export PATH="$HOME/.local/share/fnm:$PATH"
if [ -f "$HOME/.local/share/fnm/fnm" ]; then
  eval "$("$HOME/.local/share/fnm/fnm" env --shell bash)"
elif command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --shell bash)"
fi

log "Installing latest LTS Node via fnm"
if command -v fnm >/dev/null 2>&1; then
  fnm install --lts
  fnm default lts-latest
fi

log "Enabling corepack and pnpm"
if command -v corepack >/dev/null 2>&1; then
  corepack enable
  corepack prepare pnpm@latest --activate
fi

log "Installing zsh plugins"
if [ ! -d "$HOME/.zsh-plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh-plugins/zsh-autosuggestions"
fi

if [ ! -d "$HOME/.zsh-plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.zsh-plugins/zsh-syntax-highlighting"
fi

if [ ! -d "$HOME/.zsh-plugins/fzf-tab" ]; then
  git clone https://github.com/Aloxaf/fzf-tab "$HOME/.zsh-plugins/fzf-tab"
fi

log "Installing starship if missing"
if ! command -v starship >/dev/null 2>&1; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

log "Copying shell config"
cp "$WSL_DIR/.zshrc" "$HOME/.zshrc"
cp "$WSL_DIR/starship.toml" "$HOME/.config/starship.toml"

log "Configuring Zsh paths"
# Make sure local bin and snap binaries are always in the path
ensure_line 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.zshrc"
ensure_line "path+=('/snap/bin')" "$HOME/.zshrc"
ensure_line 'export PATH' "$HOME/.zshrc"

log "Copying Neovim config & Bootstrapping lazy.nvim"
rm -rf "$HOME/.config/nvim"
cp -r "$NVIM_DIR" "$HOME/.config/nvim"

LAZY_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/pack/lazy/start/lazy.nvim"
if [ ! -d "$LAZY_PATH" ]; then
  log "Downloading lazy.nvim plugin manager..."
  git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$LAZY_PATH"
fi

log "Copying VS Code WSL settings"
cp "$VSCODE_DIR/settings.json" "$HOME/.vscode-server/data/Machine/settings.json"

if [ -f "$VSCODE_DIR/keybindings.json" ]; then
  cp "$VSCODE_DIR/keybindings.json" "$HOME/.vscode-server/data/Machine/keybindings.json"
fi

log "Installing VS Code extensions in WSL"
if command -v code >/dev/null 2>&1; then
  if [ -f "$VSCODE_DIR/extensions.txt" ]; then
    grep -vE '^\s*#|^\s*$' "$VSCODE_DIR/extensions.txt" | while IFS= read -r ext; do
      code --install-extension "$ext" --force
    done
  fi
else
  echo "WARNING: 'code' command not found in WSL."
  echo "Open VS Code in WSL once with 'code .' and run this script again."
fi

log "Done"
echo
echo "Now restart the terminal, or run:"
echo "  exec zsh"
