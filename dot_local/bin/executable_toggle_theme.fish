#!/usr/bin/env fish

# Toggle dark and light themes globally, as well as for various programs that
# don't adjust with the global settings.

function is_dark
    [ "$(gsettings get org.gnome.desktop.interface color-scheme)" = "'prefer-dark'" ]
end

if is_dark
    gsettings set org.gnome.desktop.interface color-scheme default
    gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3
else
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-dark
end

# helix
sd '^theme = "(?<current_theme>[^"]+)"  # (?<other_theme>.+)$' \
    'theme = "$other_theme"  # $current_theme' \
    ~/.config/helix/config.toml
killall -USR1 hx

# fish
sd '^theme = "(?<current_theme>[^"]+)"  # (?<other_theme>.+)$' \
    'theme = "$other_theme"  # $current_theme' \
    ~/.config/fish/conf.d/theme.toml
yes | fish_config theme save "$(rg ^theme ~/.config/fish/conf.d/theme.toml | cut --delimiter '"' --fields 2)"

# alacritty
if rg ^import ~/.config/alacritty/alacritty.toml &>/dev/null
    sd '^import = ."(?<theme>[^"]+)".$' \
        '# import = ["$theme"]' \
        ~/.config/alacritty/alacritty.toml
else
    sd '^# import = ."(?<theme>[^"]+)".$' \
        'import = ["$theme"]' \
        ~/.config/alacritty/alacritty.toml
end
