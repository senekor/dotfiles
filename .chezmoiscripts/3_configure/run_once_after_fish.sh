#!/bin/bash
set -exo pipefail

sudo chsh -s "$(which fish)" "$(whoami)" &> /dev/null
