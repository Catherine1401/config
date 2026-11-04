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

check_ghostty_config() {
  local conf="$1"
  command -v ghostty >/dev/null 2>&1 || return 0
  ghostty +validate-config --config-file="$conf" >/dev/null 2>&1
}

check_fish_syntax() {
  command -v fish >/dev/null 2>&1 || return 0
  fish --no-execute "$1"
}

check "zsh: .zshrc"           check_zsh_syntax  "$DOTFILES_DIR/zsh/.zshrc"
check "zsh: .zshenv"          check_zsh_syntax  "$DOTFILES_DIR/zsh/.zshenv"
check "zsh: .p10k.zsh"        check_zsh_syntax  "$DOTFILES_DIR/zsh/.p10k.zsh"
check "fish: config.fish"     check_fish_syntax "$DOTFILES_DIR/fish/config.fish"
check "tmux: .tmux.conf"      check_tmux_conf   "$DOTFILES_DIR/tmux/.tmux.conf"
check "ghostty: config validates" check_ghostty_config "$DOTFILES_DIR/ghostty/config"
check "install.sh syntax"     check_bash_syntax "$DOTFILES_DIR/install.sh"
check "uninstall.sh syntax"   check_bash_syntax "$DOTFILES_DIR/uninstall.sh"
check "sync.sh syntax"        check_bash_syntax "$DOTFILES_DIR/sync.sh"
check "toggle-touchpad.sh syntax" check_bash_syntax "$DOTFILES_DIR/bin/toggle-touchpad.sh"
check "switch-keyboard-layout.sh syntax" check_bash_syntax "$DOTFILES_DIR/bin/switch-keyboard-layout.sh"

exit $FAILED
