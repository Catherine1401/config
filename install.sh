#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_REPO="git@github.com:Catherine1401/nvim.git"
NVIM_TARGET="$HOME/.config/nvim"

declare -A LINKS=(
  ["$DOTFILES_DIR/zsh/.zshrc"]="$HOME/.zshrc"
  ["$DOTFILES_DIR/zsh/.zshenv"]="$HOME/.zshenv"
  ["$DOTFILES_DIR/zsh/.p10k.zsh"]="$HOME/.p10k.zsh"
  ["$DOTFILES_DIR/tmux/.tmux.conf"]="$HOME/.tmux.conf"
  ["$DOTFILES_DIR/kitty/kitty.conf"]="$HOME/.config/kitty/kitty.conf"
  ["$DOTFILES_DIR/kitty/current-theme.conf"]="$HOME/.config/kitty/current-theme.conf"
  ["$DOTFILES_DIR/kitty/dark-theme.auto.conf"]="$HOME/.config/kitty/dark-theme.auto.conf"
)

link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "ok: $dst"
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "$dst.bak-$(date +%Y%m%d%H%M%S)"
    echo "backed up: $dst"
  fi
  ln -s "$src" "$dst"
  echo "linked: $dst -> $src"
}

for src in "${!LINKS[@]}"; do
  link "$src" "${LINKS[$src]}"
done

if [ ! -e "$NVIM_TARGET" ]; then
  git clone "$NVIM_REPO" "$NVIM_TARGET"
else
  echo "skip nvim: $NVIM_TARGET already exists"
fi

git -C "$DOTFILES_DIR" config core.hooksPath "$DOTFILES_DIR/.githooks"
echo "hooks: core.hooksPath -> $DOTFILES_DIR/.githooks"
