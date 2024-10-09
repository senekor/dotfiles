#!/bin/bash
set -eo pipefail

cd ~/.local/share/chezmoi
git config user.email "remo@buenzli.dev"
git remote set-url origin git@github.com:senekor/dotfiles

mkdir -p ~/repos
[ -e ~/repos/dotfiles ] || jj git init --git-repo ~/.local/share/chezmoi ~/repos/dotfiles
cd ~/repos/dotfiles
jj config set --repo user.email "remo@buenzli.dev"
jj branch track main@origin

# make git understand the relationship too, for tool support like helix
echo "gitdir: $HOME/.local/share/chezmoi/.git" > .git
echo "/*" > .jj/.gitignore
