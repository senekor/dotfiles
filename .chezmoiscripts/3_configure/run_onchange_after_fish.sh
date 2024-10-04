#!/bin/bash
set -eo pipefail

sudo chsh -s "$(which fish)" "$(whoami)" &> /dev/null
