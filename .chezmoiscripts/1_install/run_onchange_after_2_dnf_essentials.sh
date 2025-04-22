#!/bin/bash
set -eo pipefail

echo "Installing essentials..."

packages=(
    # programming language
    rustup # still need to run rustup-init
    mold clang # rust needs a linker
    gcc # maybe not needed with mold, but gcc seems good to have
    golang gopls
    nodejs yarnpkg
    uv ruff python-launcher
    shellcheck nodejs-bash-language-server

    # shell
    util-linux # chsh
    fish
    nu
    atuin

    # core util replacement
    bat

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
