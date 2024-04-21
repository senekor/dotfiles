#!/bin/bash
set -eo pipefail

conf=/etc/dnf/dnf.conf

echo "Configuring dnf..."

append_once() {
    if ! grep "$2" "$1" &> /dev/null ; then
        echo "$2" | sudo tee -a "$1" > /dev/null
    fi
}

append_once $conf "fastestmirror=True"
append_once $conf "max_parallel_downloads=10"
append_once $conf "defaultyes=True"
append_once $conf "keepcache=True"
