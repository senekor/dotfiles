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

if ! dnf repolist | grep docker &> /dev/null ; then
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
fi

if ! dnf repolist | grep code &> /dev/null ; then
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
fi

copr_repos=(
    atim/starship
    atim/nushell
    varlad/helix
    varlad/zellij
)

for copr_repo in "${copr_repos[@]}"
do
    if ! dnf repolist | grep "$(basename "$copr_repo")" &> /dev/null ; then
        sudo dnf copr enable -yq "$copr_repo"
    fi
done
