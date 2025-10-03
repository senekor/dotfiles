#!/usr/bin/env bash
set -euo pipefail

# This script is called by Helix keybindings. It's used to copy or move the
# current buffer, with the new location being entered in a fuzzel prompt.

cmd=$1
prev_name=$2

new_name=$(fuzzel --dmenu --lines 0 --prompt "$cmd: " --search $prev_name --width 64)
mkdir --parents $(dirname $new_name)
$cmd $prev_name $new_name
