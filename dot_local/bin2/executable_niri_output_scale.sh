#!/usr/bin/env bash
set -euo pipefail

# Called by niri-output-scale.desktop to adjust the scale of a monitor.

output="$(niri msg outputs | rg '^Output' | choose -f '[()]' 1 | fuzzel --dmenu --prompt 'output to scale: ')"
new_scale="1"

while true ; do
    new_scale=$(fuzzel --dmenu --lines 0 --prompt "new scale (ESC when done): " --search "$new_scale" --width 64)
    niri msg output "$output" scale "$new_scale"
done
