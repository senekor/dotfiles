#!/usr/bin/env fish

# toggle line numbers in helix' gutter

sd 'gutters = \\[(.*)\\](\\s*)#\\s\\[(.*)\\]' \
    'gutters = [$3]$2# [$1]' \
    ~/.config/helix/config.toml
