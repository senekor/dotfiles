#!/bin/bash
set -eo pipefail

echo "Enabling dnf repos..."

if ! dnf repo list | grep rpmfusion-free &> /dev/null ; then
    sudo dnf install -yq "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
fi

if ! dnf repo list | grep rpmfusion-nonfree-updates &> /dev/null ; then
    sudo dnf install -yq "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
fi

# https://docs.fedoraproject.org/en-US/quick-docs/openh264/
if ! dnf repo list | grep fedora-cisco-openh264 &> /dev/null ; then
    sudo dnf config-manager --set-enabled fedora-cisco-openh264
fi

if dnf repo list | grep phracek &> /dev/null ; then
    sudo dnf copr disable -q phracek/PyCharm
fi

if dnf repo list | grep google-chrome &> /dev/null ; then
    sudo rm /etc/yum.repos.d/google-chrome.repo
fi

if ! dnf repo list | grep "com_paulcarroty_vscodium_repo" &> /dev/null ; then
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
    varlad/zellij
# chezmoi:template:left-delimiter="# {{"
# {{ if not .isServer }}
    yalter/niri
# {{ end }}
)

for copr_repo in "${copr_repos[@]}"
do
    if ! dnf repo list | grep "$(basename "$copr_repo")" &> /dev/null ; then
        sudo dnf copr enable -yq "$copr_repo"
    fi
done
