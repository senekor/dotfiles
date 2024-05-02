#!/bin/bash
set -eo pipefail

if ! which rustup &> /dev/null ; then
    rustup-init -y --no-modify-path --component rust-analyzer
fi
