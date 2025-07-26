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
