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

repos_to_remove=(
    # preinstalled repos I don't want
    _copr:copr.fedorainfracloud.org:phracek:PyCharm.repo
    google-chrome.repo
    # repos I installed myself but don't want / need anymore:
    vscodium.repo # replaced with flatpak
    _copr:copr.fedorainfracloud.org:atim:starship.repo # via cargo-binstall
    _copr:copr.fedorainfracloud.org:claaj:typst.repo # via mise per repo
)

for repo in "${repos_to_remove[@]}" ; do
    if test -f "/etc/yum.repos.d/$repo" ; then
        sudo rm "/etc/yum.repos.d/$repo"
    fi
done

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
