complete -c jj -n "__fish_seen_subcommand_from branch; and __fish_seen_subcommand_from delete" -f -a "(jj branch list | cut --delimiter ':' --fields 1)"
complete -c jj -n "__fish_seen_subcommand_from branch; and __fish_seen_subcommand_from forget" -f -a "(jj branch list | cut --delimiter ':' --fields 1)"
complete -c jj -n "__fish_seen_subcommand_from branch; and __fish_seen_subcommand_from rename" -f -a "(jj branch list | cut --delimiter ':' --fields 1)"
complete -c jj -n "__fish_seen_subcommand_from branch; and __fish_seen_subcommand_from set" -f -a "(jj branch list | cut --delimiter ':' --fields 1)"
complete -c jj -n "__fish_seen_subcommand_from branch; and __fish_seen_subcommand_from track" -f -a "(jj branch list --all-remotes | cut --delimiter ':' --fields 1 | grep '\w@\w')"
complete -c jj -n "__fish_seen_subcommand_from branch; and __fish_seen_subcommand_from untrack" -f -a '(
for line in (jj branch list -a | cut --delimiter ":" --fields 1)
    if echo $line | grep --quiet "^\S"
        set --function __local_branch $line
        continue
    end
    if [ $line = "  @git" ]
        continue
    end
    echo "$__local_branch$(string trim $line)"
end
set --erase __local_branch
)'
