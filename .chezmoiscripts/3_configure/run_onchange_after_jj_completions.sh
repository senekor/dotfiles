#!/bin/bash
set -eo pipefail

# regenerate on jj update: {{ output "jj" "--version" | trim }}

# shellcheck disable=SC1090
source ~/.cargo/env

mkdir --parents ~/.config/fish/completions/
jj util completion fish > ~/.config/fish/completions/jj.fish

# shellcheck disable=2028 # echo may not expand escape sequences
cat ~/.local/share/chezmoi/assets/jj_completions_append.fish >> ~/.config/fish/completions/jj.fish

# regenerate when custom append file changes: {{ include "assets/jj_completions_append.fish" | sha256sum }}
