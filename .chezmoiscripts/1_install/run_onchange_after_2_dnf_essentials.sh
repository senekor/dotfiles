#!/bin/bash
set -eo pipefail

echo "Installing essentials..."

packages=(
    # programming languages
    rustup # still need to run rustup-init
    gcc # rust needs the linker from gcc
    nodejs yarnpkg
    python3-pip

    docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # essentials
    util-linux # chsh
    fish
    starship
    helix
    nushell
    make
    git-lfs

    # utils
    htop
    btop
    fd-find
    sd
    tealdeer
    ripgrep
    just
    gh
    bat
    zellij
    syncthing
    direnv
    distrobox
    difftastic
    gitui
)
installed="$(dnf list installed)"
for package in "${packages[@]}"; do
    if ! [[ $installed =~ $package ]] ; then
        sudo dnf install -y "${packages[@]}"
        break
    fi
done
