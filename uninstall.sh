#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/install.sh"

latest_backup() {
  local dst="$1" dir
  dir="$(dirname "$dst")"
  [ -d "$dir" ] || return 0
  find "$dir" -maxdepth 1 -name "$(basename "$dst").bak-[0-9]*" -print | sort | tail -n 1
}

remove_link() {
  local src="$1" dst="$2" backup=""
  if link_points_to "$dst" "$src"; then
    rm "$dst"
    echo "unlinked: $dst"
  fi

  if [ -f "$BACKUPS_FILE" ]; then
    while IFS=$'\t' read -r saved_dst saved_backup; do
      if [ "$saved_dst" = "$dst" ] && path_exists "$saved_backup"; then
        backup="$saved_backup"
      fi
    done < "$BACKUPS_FILE"
  fi
  if [ -z "$backup" ]; then
    backup="$(latest_backup "$dst")"
  fi

  if [ -n "$backup" ] && ! path_exists "$dst"; then
    mv "$backup" "$dst"
    echo "restored: $dst"
  fi
}

remove_created_paths() {
  local target
  [ -f "$CREATED_PATHS_FILE" ] || return 0
  while IFS= read -r target; do
    case "$target" in
      "$NVIM_TARGET"|"$TPM_DIR/"*|"$ZSH_PLUGIN_DIR/"*|"$ZSH_THEME_DIR/"*)
        if path_exists "$target"; then
          rm -rf -- "$target"
          echo "removed: $target"
        fi
        ;;
      *) echo "skip unsafe recorded path: $target" >&2 ;;
    esac
  done < "$CREATED_PATHS_FILE"
}

remove_created_dirs() {
  local dir
  [ -f "$CREATED_DIRS_FILE" ] || return 0
  sort -r "$CREATED_DIRS_FILE" | while IFS= read -r dir; do
    case "$dir" in
      "$HOME"/*) rmdir --ignore-fail-on-non-empty "$dir" 2>/dev/null || true ;;
      *) echo "skip unsafe recorded directory: $dir" >&2 ;;
    esac
  done
}

uninstall() {
  local answer src
  if [ "${1:-}" != "--yes" ]; then
    if [ ! -t 0 ]; then
      echo "usage: $DOTFILES_DIR/uninstall.sh [--yes]" >&2
      exit 1
    fi
    printf 'Restore previous config and delete %s? [y/N] ' "$DOTFILES_DIR"
    read -r answer
    [[ "$answer" =~ ^[Yy]$ ]] || exit 0
  fi

  for src in "${!LINKS[@]}"; do
    remove_link "$src" "${LINKS[$src]}"
  done
  remove_created_paths
  remove_created_dirs

  case "$DOTFILES_DIR" in
    /|"$HOME") echo "refusing to remove unsafe repo path: $DOTFILES_DIR" >&2; exit 1 ;;
  esac
  cd "$HOME"
  rm -rf -- "$DOTFILES_DIR"
  echo "removed repo: $DOTFILES_DIR"
}

uninstall "${1:-}"
