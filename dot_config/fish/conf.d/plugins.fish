if status is-interactive
    direnv hook fish | source
    atuin init --disable-up-arrow fish | source
end
