#!/usr/bin/env bash
set -euo pipefail

service="$1"

if systemctl --user is-active "$service" > /dev/null
then
    systemctl --user stop "$service"

    exit 0
fi

systemctl --user start "$service"
