#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_DIR="$DOTFILES_DIR/.install-state"
CREATED_PATHS_FILE="$STATE_DIR/created-paths"
CREATED_DIRS_FILE="$STATE_DIR/created-dirs"
BACKUPS_FILE="$STATE_DIR/backups"
NVIM_REPO="git@github.com:Catherine1401/nvim.git"
NVIM_TARGET="$HOME/.config/nvim"

TPM_REPO="https://github.com/tmux-plugins/tpm"
TPM_DIR="$HOME/.tmux/plugins"
TPM_TARGET="$TPM_DIR/tpm"

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
ZSH_PLUGIN_DIR="$ZSH_CUSTOM/plugins"
ZSH_THEME_DIR="$ZSH_CUSTOM/themes"
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

path_exists() {
  [ -e "$1" ] || [ -L "$1" ]
}

link_points_to() {
  [ -L "$1" ] && [ "$(readlink "$1")" = "$2" ]
}

ensure_state() {
  mkdir -p "$STATE_DIR"
}

record_once() {
  local file="$1" value="$2"
  ensure_state
  touch "$file"
  grep -Fqx -- "$value" "$file" || printf '%s\n' "$value" >> "$file"
}

ensure_parent() {
  local dir parent
  dir="$(dirname "$1")"
  parent="$dir"
  while [ "$parent" != "$HOME" ] && [ ! -d "$parent" ]; do
    record_once "$CREATED_DIRS_FILE" "$parent"
    parent="$(dirname "$parent")"
  done
  mkdir -p "$dir"
}

link() {
  local src="$1" dst="$2" backup
  ensure_parent "$dst"
  if link_points_to "$dst" "$src"; then
    echo "ok: $dst"
    return
  fi
  if path_exists "$dst"; then
    backup="$dst.bak-$(date +%Y%m%d%H%M%S)"
    ensure_state
    printf '%s\t%s\n' "$dst" "$backup" >> "$BACKUPS_FILE"
    mv "$dst" "$backup"
    echo "backed up: $dst"
  fi
  ln -s "$src" "$dst"
  echo "linked: $dst -> $src"
}

clone_if_missing() {
  local repo="$1" target="$2"
  if path_exists "$target"; then
    echo "skip: $target already exists"
  else
    ensure_parent "$target"
    record_once "$CREATED_PATHS_FILE" "$target"
    git clone "$repo" "$target"
  fi
}

install() {
  local src name plugin target
  for src in "${!LINKS[@]}"; do
    link "$src" "${LINKS[$src]}"
  done

  clone_if_missing "$NVIM_REPO" "$NVIM_TARGET"

  clone_if_missing "$TPM_REPO" "$TPM_TARGET"
  while IFS= read -r plugin; do
    target="$TPM_DIR/${plugin##*/}"
    path_exists "$target" || record_once "$CREATED_PATHS_FILE" "$target"
  done < <(awk '/^set -g @plugin / {gsub(/[\047\042]/, "", $4); print $4}' "$DOTFILES_DIR/tmux/.tmux.conf")
  "$TPM_TARGET/bin/install_plugins"

  if [ -d "$HOME/.oh-my-zsh" ]; then
    for name in "${!ZSH_CUSTOM_PLUGINS[@]}"; do
      clone_if_missing "${ZSH_CUSTOM_PLUGINS[$name]}" "$ZSH_PLUGIN_DIR/$name"
    done
    clone_if_missing "$ZSH_THEME_REPO" "$ZSH_THEME_DIR/$ZSH_THEME_NAME"
  else
    echo "skip zsh custom plugins/theme: $HOME/.oh-my-zsh not found"
  fi

  git -C "$DOTFILES_DIR" config core.hooksPath "$DOTFILES_DIR/.githooks"
  echo "hooks: core.hooksPath -> $DOTFILES_DIR/.githooks"
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  install
fi
