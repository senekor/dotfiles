#!/bin/bash
set -eo pipefail

echo "Checking for hardware specific setup..."

if sudo dmidecode | grep 'Manufacturer: Framework' &> /dev/null
then
    # hardware setup should only be run once

    if ! rg "frame.work" /usr/lib/systemd/system/fprintd.service > /dev/null
    then
        # see https://guides.frame.work/Guide/Fedora+37+Installation+on+the+Framework+Laptop/108#s655

        # Improve power saving for NVMe drives:
        sudo grubby --update-kernel=ALL --args="nvme.noacpi=1"

        # Prevent a potencial Fedora freezing issue:
        sudo grubby --update-kernel=ALL --args="psr=0"

        # Configure the fingerprint reader
        # Install the needed packages
        sudo dnf install -yq fprintd fprintd-pam

        # official workaround to enable display brightness buttons
        # https://guides.frame.work/Guide/Fedora+36+Installation+on+the+Framework+Laptop/108#s734
        sudo grubby --update-kernel=ALL --args="module_blacklist=hid_sensor_hub"

        echo '
# officially recommended setting to get fingerprint reader to work
# https://guides.frame.work/Guide/Fedora+37+Installation+on+the+Framework+Laptop/108#s655
[Install]
WantedBy=multi-user.target
' | sudo tee -a /usr/lib/systemd/system/fprintd.service > /dev/null

        sudo systemctl enable --now fprintd.service

        # enable hardware accelerated video decoding
        # https://fedoraproject.org/wiki/Firefox_Hardware_acceleration#Configure_VA-API_Video_decoding_on_Intel
        # https://community.frame.work/t/linux-battery-life-tuning/6665
        packages=(
            libva libva-utils libva-intel-driver
            intel-media-driver
        )
        sudo dnf install -y "${packages[@]}"
    fi
fi
