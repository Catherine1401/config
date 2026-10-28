#!/usr/bin/env bash
set -euo pipefail

main() {
  local -r title="Keyboard layout"
  local result keymap
  result="$(hyprctl switchxkblayout all next)"
  if [ "$result" != "ok" ]; then
    notify-send -u critical "$title" "Failed to switch layout: $result"
    exit 1
  fi
  keymap="$(hyprctl devices -j | python3 -c '
import json
import sys

keyboards = json.load(sys.stdin).get("keyboards", [])
print(keyboards[0].get("active_keymap", "unknown") if keyboards else "unknown")
')"
  notify-send "$title" "$keymap"
}

main
