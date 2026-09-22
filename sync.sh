#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

case "${1:-}" in
  pull)
    git pull
    ;;
  push)
    git add -A
    git commit -m "${2:-update config}"
    git push
    ;;
  *)
    echo "usage: $0 {pull|push [message]}"
    exit 1
    ;;
esac
