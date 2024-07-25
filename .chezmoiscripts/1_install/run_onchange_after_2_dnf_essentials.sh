#!/bin/bash
set -eo pipefail

echo "Installing essentials..."

packages=(
    # programming language
    rustup # still need to run rustup-init
    gcc # rust needs the linker from gcc
    nodejs yarnpkg
    python3-pip python3-lsp-server+all
    shellcheck nodejs-bash-language-server
    openscad clang-tools-extra

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

    # util
    ripgrep
    fd-find
    sd
    tealdeer
    fzf

    # containerization
    distrobox
    docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # service
    syncthing

    # needed by some rust crates, e.g. taplo-cli
    openssl-devel
)
installed="$(dnf list installed)"
for package in "${packages[@]}"; do
    if ! [[ $installed =~ $package ]] ; then
        sudo dnf install -y "${packages[@]}"
        break
    fi
done
