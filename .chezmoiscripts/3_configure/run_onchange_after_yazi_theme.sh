#!/bin/bash
set -euo pipefail

files=(
    "flavor.toml"
    "tmtheme.xml"
)

mkdir --parents "$HOME/.config/yazi/flavors/catppuccin-mocha.yazi/"

for file in "${files[@]}"
do
    curl --silent "https://raw.githubusercontent.com/yazi-rs/flavors/main/catppuccin-mocha.yazi/$file" > "$HOME/.config/yazi/flavors/catppuccin-mocha.yazi/$file"
done
