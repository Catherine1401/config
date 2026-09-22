#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_REPO="git@github.com:Catherine1401/nvim.git"
NVIM_TARGET="$HOME/.config/nvim"

TPM_REPO="https://github.com/tmux-plugins/tpm"
TPM_TARGET="$HOME/.tmux/plugins/tpm"

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
declare -A ZSH_CUSTOM_PLUGINS=(
  ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
  ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting"
  ["zsh-completions"]="https://github.com/zsh-users/zsh-completions"
)
ZSH_THEME_REPO="https://github.com/romkatv/powerlevel10k.git"
ZSH_THEME_NAME="powerlevel10k"

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

clone_if_missing() {
  local repo="$1" target="$2"
  if [ -e "$target" ]; then
    echo "skip: $target already exists"
  else
    git clone "$repo" "$target"
  fi
}

for src in "${!LINKS[@]}"; do
  link "$src" "${LINKS[$src]}"
done

clone_if_missing "$NVIM_REPO" "$NVIM_TARGET"

clone_if_missing "$TPM_REPO" "$TPM_TARGET"
"$TPM_TARGET/bin/install_plugins"

if [ -d "$HOME/.oh-my-zsh" ]; then
  for name in "${!ZSH_CUSTOM_PLUGINS[@]}"; do
    clone_if_missing "${ZSH_CUSTOM_PLUGINS[$name]}" "$ZSH_CUSTOM/plugins/$name"
  done
  clone_if_missing "$ZSH_THEME_REPO" "$ZSH_CUSTOM/themes/$ZSH_THEME_NAME"
else
  echo "skip zsh custom plugins/theme: $HOME/.oh-my-zsh not found"
fi

git -C "$DOTFILES_DIR" config core.hooksPath "$DOTFILES_DIR/.githooks"
echo "hooks: core.hooksPath -> $DOTFILES_DIR/.githooks"
