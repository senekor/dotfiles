if status is-interactive

    # Use Shift-Tab to step one word ahead in the suggestion.
    #
    # The default keybinding for this is Alt-RightArrow.
    # But this clashes with the zellij keybinding for moving between panes.
    # It is also slightly inconvenient to typo on my layout.
    #
    # The default action of Shift-Tab is to start a search within all possible
    # tab completions. Double-tapping tab does the same thing, which I do
    # anyway when a single tab doesn't immediately give me what I want.
    #
    # The relevant information can be found in the web configuration of fish
    # (`fish_config`) under the tab "bindings". `help bind` also has some
    # useful information.
    #
    bind --key btab nextd-or-forward-word
end
