#!/bin/bash
set -eo pipefail

echo "Enable SSH daemon with password authentication disabled..."
sudo sed --in-place 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sudo systemctl enable --now sshd
