#!/bin/bash
set -eo pipefail

echo "Installing essentials..."

packages=(
    # programming language
    rustup # still need to run rustup-init
    gcc # rust needs the linker from gcc
    nodejs yarnpkg
    python3-pip python3-lsp-server+all uv python-launcher
    shellcheck nodejs-bash-language-server

    # shell
    util-linux # chsh
    fish
    nu
    starship

    # core util replacement
    bat
    eza

    # repo interaction
    make
    just
    direnv

    # git
    git-lfs
    difftastic
    gitui
    gh

    # TUI
    htop btop
    helix
    zellij
    glow

    # util
    ripgrep
    fd-find
    sd
    tealdeer
    fzf
    patch

    # containerization
    distrobox

    # service
    syncthing

    # needed by some rust crates, e.g. taplo-cli
    openssl-devel
)
installed="$(dnf list --installed)"
for package in "${packages[@]}"; do
    if ! [[ $installed =~ $package ]] ; then
        sudo dnf install -y "${packages[@]}"
        break
    fi
done
