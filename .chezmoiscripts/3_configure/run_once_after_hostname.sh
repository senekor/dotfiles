#!/bin/bash
set -eo pipefail

if [ "$(hostname)" = "fedora" ]
then
    echo "Enter a new hostname:"
    read -r new_hostname
    hostnamectl set-hostname "$new_hostname"
fi
