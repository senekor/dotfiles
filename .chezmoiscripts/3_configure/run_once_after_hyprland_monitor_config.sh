#!/bin/bash
set -eo pipefail

if ! [ -f ~/.config/hypr/monitors.conf ]
then
    cp ~/.local/share/chezmoi/dot_config/hypr/monitors.example.conf ~/.config/hypr/monitors.conf
fi
