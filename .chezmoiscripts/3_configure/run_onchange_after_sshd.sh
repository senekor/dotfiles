#!/bin/bash
set -eo pipefail

echo "Enable SSH daemon with password authentication disabled..."
sudo sd '#PasswordAuthentication yes' 'PasswordAuthentication no' /etc/ssh/sshd_config
sudo systemctl enable --now sshd
