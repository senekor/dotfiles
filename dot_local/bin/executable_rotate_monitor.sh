#!/bin/bash
set -euo pipefail

# usually called via keybind, see hyprland.conf

current_rotation=$(
  rg 'rotation = ' ~/.config/hypr/monitors.conf \
    | choose --field-separator 'rotation = ' 1
)
case $current_rotation in
  0) next_rotation=1 ;;
  1) next_rotation=3 ;;
  3) next_rotation=0 ;;
  *)
    err="unknown current rotation: '$current_rotation' (expected 0,1 or 3)"
    echo "$err" >&2
    notify-send --urgency=critical "$err"
    exit 1
    ;;
esac

sd 'rotation = \d' "rotation = $next_rotation" ~/.config/hypr/monitors.conf
