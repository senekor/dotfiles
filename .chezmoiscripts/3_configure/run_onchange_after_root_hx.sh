#!/bin/bash
set -eo pipefail

# trigger a rerun of this script if the helix config changes
#
# helix config hash: {{ include "dot_config/helix/config.toml" | sha256sum }}

sudo mkdir -p "/root/.config/helix"
sd --preview '^theme.*$' 'theme = "zenburn"' "$HOME/.config/helix/config.toml" \
    | sudo tee "/root/.config/helix/config.toml" > /dev/null
