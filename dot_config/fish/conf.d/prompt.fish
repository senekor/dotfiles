if status is-interactive
    # disable greeting
    set --global --export fish_greeting

    starship init fish | source
end
