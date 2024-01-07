if status is-interactive
    direnv hook fish | source
    atuin init --disable-up-arrow fish | source

    # 1password plugins
    alias cargo "op plugin run -- cargo"
    alias gh "op plugin run -- gh"
end
