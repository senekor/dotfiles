COMPLETE=fish jj | source

# complete `bookmark create` with push prefix
complete --command jj \
    --condition "__fish_seen_subcommand_from b bookmark; and __fish_seen_subcommand_from c create" \
    --arguments "(jj config get git.push-bookmark-prefix)"

# complete `jj clone` and `jj git remote add / set-url` with repo url
complete --command jj \
    --condition "__fish_seen_subcommand_from clone" \
    --arguments "(__jj_clone (commandline --current-token))"
complete --command jj \
    --condition "__fish_seen_subcommand_from git ; and __fish_seen_subcommand_from remote ; __fish_seen_subcommand_from add" \
    --arguments "(__jj_clone (commandline --current-token))"
complete --command jj \
    --condition "__fish_seen_subcommand_from git ; and __fish_seen_subcommand_from remote ; __fish_seen_subcommand_from set-url" \
    --arguments "(__jj_clone (commandline --current-token))"

function __jj_clone --argument-names token
    if string match "git@*" $token &>/dev/null
        __jj_clone_from_host (string sub --start 5 $token)
        return
    end
    echo "git@"
end
function __jj_clone_from_host --argument-names token
    set --local hosts
    for host in ~/repos/*.* # at least one dot for domains
        set --append hosts (basename $host)
    end
    for host in $hosts
        set --local host (basename $host)
        if string match "$host*" $token &>/dev/null
            set --local offset (math "$(string length $host) - 1")
            set --local token (string sub --start $offset $token)
            __jj_clone_from_owner $host $token
            return
        end
    end
    printf "git@%s:\n" $hosts
end
function __jj_clone_from_owner --argument-names host token
    set --local owners
    for owner in ~/repos/$host/*/
        set --append owners (basename $owner)
    end
    for owner in $owners
        if string match "$owner*" $token &>/dev/null
            # set --local offset (math "$(string length $owner) - 1")
            # set --local token (string sub --start $offset $token)
            # __jj_clone_from_owner $host $token
            return
        end
    end
    printf "git@$host:%s/\n" $owners
end
