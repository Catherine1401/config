#!/usr/bin/env bash
set -uo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FAILED=0

check() {
  local desc="$1"; shift
  if "$@"; then
    echo "PASS: $desc"
  else
    echo "FAIL: $desc"
    FAILED=1
  fi
}

check_zsh_syntax() { zsh -n "$1"; }
check_bash_syntax() { bash -n "$1"; }

check_tmux_conf() {
  local sock="dotfiles-test-$$"
  tmux -L "$sock" -f /dev/null start-server \; source-file "$1"
  local ok=$?
  tmux -L "$sock" kill-server 2>/dev/null
  return $ok
}

check_kitty_includes() {
  local conf="$1" dir target
  dir="$(dirname "$conf")"
  while IFS= read -r target; do
    [ -f "$dir/$target" ] || return 1
  done < <(grep -E '^include ' "$conf" | awk '{print $2}')
  return 0
}

check "zsh: .zshrc"           check_zsh_syntax  "$DOTFILES_DIR/zsh/.zshrc"
check "zsh: .zshenv"          check_zsh_syntax  "$DOTFILES_DIR/zsh/.zshenv"
check "zsh: .p10k.zsh"        check_zsh_syntax  "$DOTFILES_DIR/zsh/.p10k.zsh"
check "tmux: .tmux.conf"      check_tmux_conf   "$DOTFILES_DIR/tmux/.tmux.conf"
check "kitty: includes resolve" check_kitty_includes "$DOTFILES_DIR/kitty/kitty.conf"
check "install.sh syntax"     check_bash_syntax "$DOTFILES_DIR/install.sh"
check "sync.sh syntax"        check_bash_syntax "$DOTFILES_DIR/sync.sh"

exit $FAILED
