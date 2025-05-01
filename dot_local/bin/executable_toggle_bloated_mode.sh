#!/usr/bin/env bash
set -euo pipefail

if rg -q "gaps 16" ~/.config/niri/config.kdl
then
    sd 'gaps \d+' 'gaps 0' ~/.config/niri/config.kdl
    sd '// off // focus-ring' 'off // focus-ring' ~/.config/niri/config.kdl
    sd 'window-rule \{ // rounded corners' '/-window-rule { // rounded corners' ~/.config/niri/config.kdl

    exit 0
fi

sd 'gaps \d+' 'gaps 16' ~/.config/niri/config.kdl
sd 'off // focus-ring' '// off // focus-ring' ~/.config/niri/config.kdl
sd '/-window-rule \{ // rounded corners' 'window-rule { // rounded corners' ~/.config/niri/config.kdl
