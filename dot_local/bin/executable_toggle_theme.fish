#!/usr/bin/env fish

# toggle dark and light themes for various programs

# helix
sd '^theme = "(?<current_theme>[^"]+)" # (?<other_theme>.+)$' \
    'theme = "$other_theme" # $current_theme' \
    ~/.config/helix/config.toml
killall -USR1 hx

# fish
sd '^theme = "(?<current_theme>[^"]+)" # (?<other_theme>.+)$' \
    'theme = "$other_theme" # $current_theme' \
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
