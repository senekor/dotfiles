#!/usr/bin/env fish

# Toggle dark and light themes globally, as well as for various programs that
# don't adjust with the global (GTK) settings.

if test "$(gsettings get org.gnome.desktop.interface color-scheme)" = "'prefer-dark'"
    gsettings set org.gnome.desktop.interface color-scheme default
    gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3
    sd 'theme = ".*"' 'theme = "modus_operandi"' ~/.config/helix/config.toml
    yes | fish_config theme save "Snow Day"
    sd '# import' import ~/.config/alacritty/alacritty.toml
    sd 'theme ".*"' 'theme "iceberg-light"' ~/.config/zellij/config.kdl
    sd 'color_theme = ".*"' 'color_theme = "whiteout"' ~/.config/btop/btop.conf
    sd '^"diff added token".*$' '"diff added token" = { bg = "#c0e0c0", fg = "#000000" }' ~/.config/jj/config.toml
    sd '^"diff removed token".*$' '"diff removed token" = { bg = "#e0c0c0", fg = "#000000" }' ~/.config/jj/config.toml
else
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-dark
    sd 'theme = ".*"' 'theme = "kanagawa_deluxe"' ~/.config/helix/config.toml
    yes | fish_config theme save "ayu Dark"
    sd '^import' '# import' ~/.config/alacritty/alacritty.toml
    sd 'theme ".*"' 'theme "kanagawa"' ~/.config/zellij/config.kdl
    sd 'color_theme = ".*"' 'color_theme = "Default"' ~/.config/btop/btop.conf
    sd '^"diff added token".*$' '"diff added token" = { bg = "#204020", fg = "#bbddbb" }' ~/.config/jj/config.toml
    sd '^"diff removed token".*$' '"diff removed token" = { bg = "#402020", fg = "#ddbbbb" }' ~/.config/jj/config.toml
end

killall -USR1 hx
killall -USR2 btop
