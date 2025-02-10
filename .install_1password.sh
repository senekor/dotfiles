#!/bin/bash

if [ -z "$BASH_VERSION" ] ; then
    echo "ERROR: This script must be sourced in bash."
    exit 1
fi
if ! (return 0 2>/dev/null) ; then
    echo "ERROR: This script must be sourced."
    exit 1
fi

echo "Installing 1Password..."
sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'

if ! [ "$(systemctl get-default)" = "graphical.target" ] ; then
    exit # server doesn't have access to 1Password
fi

sudo dnf install -y git 1password 1password-cli age wl-clipboard

secret_sauce="/run/media/$USER/remo/setup/secret_sauce.age"
if ! [ -f "$secret_sauce" ] ; then
    echo "Last opportunity to add secret sauce!"
    printf "Press enter to continue."
    read -r _
fi
if [ -f "$secret_sauce" ] ; then
    echo "Adding secret sauce..."
    if ! age --decrypt "$secret_sauce" | wl-copy ; then
        echo "Failed to add secret sauce :-( Let's keep going anyway."
    fi
fi

1password &> /dev/null &
disown %1

printf "Please login to 1Password, then press enter to continue."
read -r _
printf "Did you enable the SSH agent and CLI integration in the settings? :-)"
read -r _
