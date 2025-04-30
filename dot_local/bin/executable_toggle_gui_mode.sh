#!/usr/bin/env bash
set -euo pipefail

# TODO change niri config to be more space-wasteful and fancy in bloated mode

if systemctl --user is-active waybar.service > /dev/null ; then
    systemctl --user stop waybar.service
    exit 0
fi

systemctl --user start waybar.service
