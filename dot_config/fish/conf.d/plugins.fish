if status is-interactive
    direnv hook fish | source
    atuin init --disable-up-arrow fish | source

    # 1password plugins
    export OP_PLUGIN_ALIASES_SOURCED=1
    alias cargo "op plugin run -- cargo"
    alias gh "op plugin run -- gh"
end
