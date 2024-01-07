#!/bin/bash
set -eo pipefail

cd ~/.local/share/chezmoi
git remote set-url origin git@github.com:senekor/dotfiles
