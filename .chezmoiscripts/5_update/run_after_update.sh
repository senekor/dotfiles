#!/bin/bash
set -eo pipefail

echo "Performing system update..."
sudo dnf update -y

echo "Making sure rust is up to date..."
source "$HOME/.cargo/env"
rustup --quiet update

tldr --update &> /dev/null
