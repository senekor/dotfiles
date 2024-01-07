#!/bin/bash
set -exo pipefail

if ! which rustup &> /dev/null ; then
    rustup-init -y --no-modify-path
fi
