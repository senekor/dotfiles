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
    set lines (cat ~/.ssh/config | string split "\n")
    set len (count $lines)

    set i 1
    while [ $i -le $len ]
        set words (echo $lines[$i] | string split " ")
        if [ $words[1] = Host ] && [ $lines[(math "$i + 1")] = "  User git" ]
            set --local host $words[2]
            set --append hosts $host
            set --local long_host (echo $lines[(math "$i + 2")] | string sub --start 12)
            set --append long_hosts $long_host

            if string match "$host:*" $token &>/dev/null || string match "$long_host:*" $token &>/dev/null
                set --local offset (math "$(string length $host) - 1")
                set --local token (string sub --start $offset $token)
                __jj_clone_from_owner $host $long_host $token
                return
            end
        end
        set i (math "$i + 1")
    end

    printf "%s:\n" $hosts
end
function __jj_clone_from_owner --argument-names host long_host token
    set --local fragments (echo $long_host | string split ".")
    set --local short_long_host $fragments[-2]
    set --local owners
    for owner in ~/repos/$short_long_host/*/
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
    printf "$host:%s/\n" $owners
end
