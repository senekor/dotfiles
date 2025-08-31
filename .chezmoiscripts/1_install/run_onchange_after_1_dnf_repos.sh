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

if ! dnf repo list | grep "com_paulcarroty_vscodium_repo" &> /dev/null ; then
    # The vscodium flatpak is kinda bad / applies too much isolation.
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

repos_to_remove=(
    # preinstalled repos I don't want
    _copr:copr.fedorainfracloud.org:phracek:PyCharm.repo
    google-chrome.repo
    # repos I installed myself but don't want / need anymore:
    _copr:copr.fedorainfracloud.org:atim:starship.repo # via cargo-binstall
    _copr:copr.fedorainfracloud.org:claaj:typst.repo # via mise per repo
    _copr:copr.fedorainfracloud.org:varlad:zellij.repo # via cargo-binstall
    docker-ce.repo # screw docker
)

for repo in "${repos_to_remove[@]}" ; do
    if test -f "/etc/yum.repos.d/$repo" ; then
        sudo rm "/etc/yum.repos.d/$repo"
    fi
done

copr_repos=(
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
