#!/bin/bash
set -euo pipefail

# usually called via keybind, see niri/config.kdl

current_rotation=$(
  rg 'transform "[a-z0-9]*" // rotatable' ~/.config/niri/config.kdl \
    | choose --field-separator ' ' 1
)
case $current_rotation in
  '"normal"') next_rotation='"90"'     ;;
      '"90"') next_rotation='"270"'    ;;
     '"270"') next_rotation='"normal"' ;;
  *)
    err="unknown current rotation: '$current_rotation' (expected normal, 90 or 270)"
    echo "$err" >&2
    notify-send --urgency=critical "$err"
    exit 1
    ;;
esac

sd 'transform "[a-z0-9]*" // rotatable' "transform $next_rotation // rotatable" ~/.config/niri/config.kdl
