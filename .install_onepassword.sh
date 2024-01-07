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

if [ "$(systemctl get-default)" = "graphical.target" ]
then
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
else
    # System has no GUI, probably a server.
    sudo dnf install -y git 1password-cli

    # Presumably we will access 1password not by logging in,
    # but rather with a service account token. Install that.
    echo "Please enter the 1Password service account token."
    read -r -s token

    # chezmoi clears the environment when invoking op.
    # We therefore create a little wrapper that laods the token back in.
    mkdir -p ~/.config/opw/
    echo -n "$token" > ~/.config/opw/token
    mkdir -p ~/.local/bin
    # shellcheck disable=2016
    echo '#!/bin/bash
if [ "$1" = "signin" ] ; then echo "fake-token" ; exit 0 ; fi
export OP_SERVICE_ACCOUNT_TOKEN=$(cat ~/.config/opw/token)
op "$@"' > ~/.local/bin/opw
    chmod +x ~/.local/bin/opw
    export PATH="$PATH:$HOME/.local/bin"

    # configure chezmoi to use the wrapper upon first init
    mkdir -p ~/.config/chezmoi
    echo 'onepassword.command = "opw"' > ~/.config/chezmoi/chezmoi.toml
fi
