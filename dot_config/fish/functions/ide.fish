function ide
    # cut command needed for symlinks, e.g. 'dotfiles -> ~/.local/share/chezmoi'
    set repos (ls ~/repos | cat | cut --delimiter ' ' --fields 1)
    if set --query argv[1]
        set repo $argv[1]
    else
        set repo (printf '%s\n' $repos | fzf)
    end
    if test $repo = ""
        return
    end
    if contains $repo $repos
        if zellij list-sessions --short | rg --quiet --fixed-strings -- "$repo"
            zellij attach "$repo"
        else
            pushd ~/repos/$repo
            zellij --layout ide --session $repo
            popd
        end
    else if test -d $repo
        pushd $repo
        zellij --layout ide
        popd
    else
        set_color --bold brred
        echo -n "ERROR "
        set_color normal
        echo "'$repo' not found"
    end
end
