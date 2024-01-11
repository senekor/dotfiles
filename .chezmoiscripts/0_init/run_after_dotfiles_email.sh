#!/bin/bash
set -eo pipefail

cd ~/repos/dotfiles
git config user.email "$(op read op://chezmoi/none/email)"
