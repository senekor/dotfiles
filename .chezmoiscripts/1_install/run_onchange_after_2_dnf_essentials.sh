#!/bin/bash
set -eo pipefail

echo "Installing essentials..."

packages=(
    # programming language
    rustup # still need to run rustup-init
    gcc # rust needs a linker
    golang gopls
    nodejs yarnpkg
    uv ruff python-launcher
    shellcheck nodejs-bash-language-server

    # shell
    util-linux # chsh
    fish
    nu
    atuin

    # git
    git-lfs
    difftastic
    gitui
    gh

    # TUI
    htop btop
    helix
    zellij

    # util
    make
    ripgrep
    fd-find
    bat
    du-dust
    tealdeer
    fzf
    patch
    boxes
    pwgen
    aha

    # containerization
    distrobox

    # service
    syncthing
    msmtp s-nail

    # needed by some rust crates
    openssl-devel
)
installed="$(dnf list --installed)"
for package in "${packages[@]}"; do
    if ! [[ $installed =~ $package ]] ; then
        sudo dnf install -y "${packages[@]}"
        break
    fi
done
