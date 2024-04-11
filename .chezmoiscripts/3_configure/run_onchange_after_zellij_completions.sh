#!/bin/bash
set -exo pipefail

# regenerate on zellij update: {{ output "zellij" "--version" | trim }}

mkdir --parents ~/.config/fish/completions/
zellij setup --generate-completion fish > ~/.config/fish/completions/zellij.fish
