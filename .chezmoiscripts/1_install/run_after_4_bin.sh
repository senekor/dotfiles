#!/bin/bash
set -eo pipefail

echo "Making sure prebuilt binaries are installed..."

# make sure cargo in in PATH during system bootstrapping
# shellcheck source=/dev/null
source "$HOME/.cargo/env"

if ! which cargo-binstall &> /dev/null ; then
    echo "installing cargo-binstall..."
    curl -L --proto '=https' --tlsv1.2 -sSf \
        https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh \
        | bash
fi

packages=(
    cargo-generate
    cargo-nextest
    atuin
)

cargo binstall -y --log-level warn "${packages[@]}"

# TODO install with cargo-binstall once cargo-dist is setup
cargo install git-quickprune

[ -d "$HOME/.local/bin" ] || mkdir -p "$HOME/.local/bin"
