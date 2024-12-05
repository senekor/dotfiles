function ide
    argparse fzf -- $argv
    if ! set --query --local _flag_fzf
        zellij --layout ide
        return
    end

    set --local repo_offset (math "$(string length ~/repos) + 2")
    for domain in ~/repos/*
        # plain repos directly in ~/repos are also allowed
        if [ -e $domain/.git ]
            set --append repos (string sub --start $repo_offset $domain)
            continue
        end
        for repo in $domain/*/*
            set --append repos (string sub --start $repo_offset $repo)
        end
    end
    set repo (printf '%s\n' $repos | fzf)
    if test "$repo" = ""
        set_color --bold brred
        echo -n "ERROR "
        set_color normal
        echo "no repository chosen"
        return
    end
    pushd ~/repos/$repo
    zellij --layout ide
    popd
end
