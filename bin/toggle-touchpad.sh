#!/usr/bin/env bash
set -euo pipefail

main() {
  local -r runtime_dir="${XDG_RUNTIME_DIR:?XDG_RUNTIME_DIR is required}"
  local -r flag="$runtime_dir/touchpad-disabled-${HYPRLAND_INSTANCE_SIGNATURE:-default}"
  local -r title="Touchpad"
  local -r enabled_message="Đã bật"
  local -r disabled_message="Đã tắt"
  local -r parser='
import json
import sys

enabled = sys.argv[1]
device_key = "mice"
name_key = "name"
touchpad_label = "touchpad"
missing_message = "No touchpad found in Hyprland devices."
command_template = "hl.device({ name = %s, enabled = %s })"
separator = "; "
names = [device[name_key] for device in json.load(sys.stdin).get(device_key, [])
         if touchpad_label in device.get(name_key, "").lower()]
if not names:
    sys.exit(missing_message)
print(separator.join(command_template % (json.dumps(name, ensure_ascii=False), enabled)
                     for name in names))
'
  local enabled=false message="$disabled_message" devices command
  if [ -f "$flag" ]; then
    enabled=true
    message="$enabled_message"
  fi
  devices="$(hyprctl devices -j)"
  command="$(python3 -c "$parser" "$enabled" <<< "$devices")"
  hyprctl eval "$command"
  if [ "$enabled" = true ]; then
    rm -f -- "$flag"
  else
    touch -- "$flag"
  fi
  notify-send "$title" "$message"
}

main
