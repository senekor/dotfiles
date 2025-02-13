#!/bin/bash
set -eo pipefail

echo "Enabling dnf repos..."

if ! dnf repolist | grep rpmfusion-free &> /dev/null ; then
    sudo dnf install -yq "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
fi

if ! dnf repolist | grep rpmfusion-nonfree-updates &> /dev/null ; then
    sudo dnf install -yq "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
fi

# https://docs.fedoraproject.org/en-US/quick-docs/openh264/
if ! dnf repolist | grep fedora-cisco-openh264 &> /dev/null ; then
    sudo dnf config-manager --set-enabled fedora-cisco-openh264
fi

if dnf repolist | grep phracek &> /dev/null ; then
    sudo dnf copr disable -q phracek/PyCharm
fi

if ! dnf repolist | grep "com_paulcarroty_vscodium_repo" &> /dev/null ; then
    sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
    printf "
[gitlab.com_paulcarroty_vscodium_repo]
name=download.vscodium.com
baseurl=https://download.vscodium.com/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
metadata_expire=1h
" | sudo tee -a /etc/yum.repos.d/vscodium.repo > /dev/null
fi

copr_repos=(
    atim/starship
    varlad/zellij
)

for copr_repo in "${copr_repos[@]}"
do
    if ! dnf repolist | grep "$(basename "$copr_repo")" &> /dev/null ; then
        sudo dnf copr enable -yq "$copr_repo"
    fi
done
