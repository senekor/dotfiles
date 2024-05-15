#!/bin/bash
set -eo pipefail

# regenerate on jj update: {{ output "jj" "--version" | trim }}

mkdir --parents ~/.config/fish/completions/
jj util completion fish > ~/.config/fish/completions/jj.fish
