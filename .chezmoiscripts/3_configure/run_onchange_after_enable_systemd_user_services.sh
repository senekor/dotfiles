#!/bin/bash
set -euo pipefail

services=(
    1password.service
)

for service in "${services[@]}"; do
    systemctl --user enable "$service"
done
