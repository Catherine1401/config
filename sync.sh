#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_DIR="$HOME/.config/nvim"

REPOS=("$DOTFILES_DIR")
[ -d "$NVIM_DIR/.git" ] && REPOS+=("$NVIM_DIR")

case "${1:-}" in
  pull)
    for repo in "${REPOS[@]}"; do
      echo "== pull: $repo =="
      git -C "$repo" pull
    done
    ;;
  push)
    for repo in "${REPOS[@]}"; do
      echo "== push: $repo =="
      git -C "$repo" add -A
      if git -C "$repo" diff --cached --quiet; then
        echo "nothing to push"
        continue
      fi
      git -C "$repo" commit -m "${2:-update config}"
      git -C "$repo" push
    done
    ;;
  *)
    echo "usage: $0 {pull|push [message]}"
    exit 1
    ;;
esac
