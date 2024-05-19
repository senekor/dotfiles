complete -c jj -n "__fish_seen_subcommand_from branch; and __fish_seen_subcommand_from delete" -f -a "(jj branch list -T 'name ++ \"\n\"')"
complete -c jj -n "__fish_seen_subcommand_from branch; and __fish_seen_subcommand_from forget" -f -a "(jj branch list -T 'name ++ \"\n\"')"
complete -c jj -n "__fish_seen_subcommand_from branch; and __fish_seen_subcommand_from rename" -f -a "(jj branch list -T 'name ++ \"\n\"')"
complete -c jj -n "__fish_seen_subcommand_from branch; and __fish_seen_subcommand_from set" -f -a "(jj branch list -T 'name ++ \"\n\"')"
complete -c jj -n "__fish_seen_subcommand_from branch; and __fish_seen_subcommand_from track" -f -a "(jj branch list -a -T 'if(remote && !tracked, name ++ \"@\" ++ remote ++ \"\n\")')"
complete -c jj -n "__fish_seen_subcommand_from branch; and __fish_seen_subcommand_from untrack" -f -a "(jj branch list -a -T 'if(tracked && !\"git\".contains(remote), name ++ \"@\" ++ remote ++ \"\n\")')"
