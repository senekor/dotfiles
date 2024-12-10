function __fish_just_complete_recipes
    if string match -rq '(-f|--justfile)\s*=?(?<justfile>[^\s]+)' -- (string split -- ' -- ' (commandline -pc))[1]
        set -fx JUST_JUSTFILE "$justfile"
    end

    # We need the command line tokens to compare them against the module path
    # of recipies within modules.
    set commandline_tokens (commandline --current-process --tokenize --cut-at-cursor)

    # Used to track the deepest matching module path. Once a path of a certain
    # depth matches, all suggestions with shorter paths are invalidated.
    set max_matching_module_depth 1

    for line in (just --list --list-heading='' --list-prefix='>' --list-submodules 2>/dev/null)
        if [ $line = '' ]
            continue
        end

        # Determine the module depth of the current recipe.
        set depth 0
        while [ (string sub --end 1 $line) = '>' ]
            set depth (math "$depth + 1")
            set line (string sub --start 2 $line)
        end
        if [ (string sub --end 1 $line) = '[' ]
            # Group headings start with '[', ignore this line.
            continue
        end
        if [ $depth -lt $max_matching_module_depth ]
            # We have previously found a deeper matching module. There is no
            # chance any other recipes will match from this point forward.
            break
        end
        # Pop segments off the module stack that aren't valid anymore.
        for i in (seq $depth (count $module_stack))
            set --erase module_stack[$i]
        end
        set cmd_args_desc (string split " # " $line)
        set cmd_args "$cmd_args_desc[1]"
        set desc "$cmd_args_desc[2]"

        set cmd_args (string split " " $cmd_args)
        set cmd "$cmd_args[1]"
        set args "$cmd_args[2]"

        # Detect modules based on the colon at the end. Strip the colon for
        # completions and add it to the module stack.
        if [ (string sub --start -1 $cmd) = ':' ]
            set cmd (string sub --end -1 $cmd)
            set --append module_stack $cmd
        end

        # If the current recipe is within a module, make sure its path is
        # present on the commandline.
        if [ $depth -gt 1 ]
            set modules_to_find $module_stack[1..(math "$depth - 1")]
            set num_modules (count $modules_to_find)
            set commandline_offset (math "$(count $commandline_tokens) - $num_modules + 1")

            if [ $commandline_offset -lt 1 ]
                # The current commandline is shorter than the module path of
                # the current recipe. No way it will match.
                continue
            end

            set commandline_tail $commandline_tokens[$commandline_offset..-1]

            if [ "$modules_to_find" != "$commandline_tail" ]
                # The module path of the current recipe isn't on the
                # commandline, so we shouldn't suggest it.
                continue
            end

            if [ $depth -gt $max_matching_module_depth ]
                set max_matching_module_depth $depth
                # All the previous suggestions are now invalid, because they
                # matched a shorter module path.
                set --erase suggestions
            end
        end

        # Register current recipe as suggestion. It may be invalidated later if
        # a longer module path matches.
        if [ "$args" != '' ]
            if [ "$desc" != '' ]
                set --append suggestions "$cmd\tArgs: $args; $desc"
            else
                set --append suggestions "$cmd\tArgs: $args"
            end
        else
            if [ "$desc" != '' ]
                set --append suggestions "$cmd\t$desc"
            else
                set --append suggestions "$cmd"
            end
        end
    end

    # Print the final suggestions
    for s in $suggestions
        printf "$s\n"
    end
end

# don't suggest files
complete -c just --no-files

# complete recipes
complete -c just -a '(__fish_just_complete_recipes)'

# autogenerated completions
complete -c just -l chooser -d 'Override binary invoked by `--choose`' -r
complete -c just -l color -d 'Print colorful output' -r -f -a "{auto\t'',always\t'',never\t''}"
complete -c just -l command-color -d 'Echo recipe lines in <COMMAND-COLOR>' -r -f -a "{black\t'',blue\t'',cyan\t'',green\t'',purple\t'',red\t'',yellow\t''}"
complete -c just -l dotenv-filename -d 'Search for environment file named <DOTENV-FILENAME> instead of `.env`' -r
complete -c just -s E -l dotenv-path -d 'Load <DOTENV-PATH> as environment file instead of searching for one' -r -F
complete -c just -l dump-format -d 'Dump justfile as <FORMAT>' -r -f -a "{json\t'',just\t''}"
complete -c just -s f -l justfile -d 'Use <JUSTFILE> as justfile' -r -F
complete -c just -l list-heading -d 'Print <TEXT> before list' -r
complete -c just -l list-prefix -d 'Print <TEXT> before each list item' -r
complete -c just -l set -d 'Override <VARIABLE> with <VALUE>' -r
complete -c just -l shell -d 'Invoke <SHELL> to run recipes' -r
complete -c just -l shell-arg -d 'Invoke shell with <SHELL-ARG> as an argument' -r
complete -c just -l timestamp-format -d 'Timestamp format string' -r
complete -c just -s d -l working-directory -d 'Use <WORKING-DIRECTORY> as working directory. --justfile must also be set' -r -F
complete -c just -s c -l command -d 'Run an arbitrary command with the working directory, `.env`, overrides, and exports set' -r
complete -c just -l completions -d 'Print shell completion script for <SHELL>' -r -f -a "{bash\t'',elvish\t'',fish\t'',nushell\t'',powershell\t'',zsh\t''}"
complete -c just -s l -l list -d 'List available recipes' -r
complete -c just -s s -l show -d 'Show recipe at <PATH>' -r
complete -c just -l check -d 'Run `--fmt` in \'check\' mode. Exits with 0 if justfile is formatted correctly. Exits with 1 and prints a diff if formatting is required.'
complete -c just -l clear-shell-args -d 'Clear shell arguments'
complete -c just -s n -l dry-run -d 'Print what just would do without doing it'
complete -c just -l explain -d 'Print recipe doc comment before running it'
complete -c just -s g -l global-justfile -d 'Use global justfile'
complete -c just -l highlight -d 'Highlight echoed recipe lines in bold'
complete -c just -l list-submodules -d 'List recipes in submodules'
complete -c just -l no-aliases -d 'Don\'t show aliases in list'
complete -c just -l no-deps -d 'Don\'t run recipe dependencies'
complete -c just -l no-dotenv -d 'Don\'t load `.env` file'
complete -c just -l no-highlight -d 'Don\'t highlight echoed recipe lines in bold'
complete -c just -l one -d 'Forbid multiple recipes from being invoked on the command line'
complete -c just -s q -l quiet -d 'Suppress all output'
complete -c just -l shell-command -d 'Invoke <COMMAND> with the shell used to run recipe lines and backticks'
complete -c just -l timestamp -d 'Print recipe command timestamps'
complete -c just -s u -l unsorted -d 'Return list and summary entries in source order'
complete -c just -l unstable -d 'Enable unstable features'
complete -c just -s v -l verbose -d 'Use verbose output'
complete -c just -l yes -d 'Automatically confirm all recipes.'
complete -c just -l changelog -d 'Print changelog'
complete -c just -l choose -d 'Select one or more recipes to run using a binary chooser. If `--chooser` is not passed the chooser defaults to the value of $JUST_CHOOSER, falling back to `fzf`'
complete -c just -l dump -d 'Print justfile'
complete -c just -s e -l edit -d 'Edit justfile with editor given by $VISUAL or $EDITOR, falling back to `vim`'
complete -c just -l evaluate -d 'Evaluate and print all variables. If a variable name is given as an argument, only print that variable\'s value.'
complete -c just -l fmt -d 'Format and overwrite justfile'
complete -c just -l groups -d 'List recipe groups'
complete -c just -l init -d 'Initialize new justfile in project root'
complete -c just -l man -d 'Print man page'
complete -c just -l summary -d 'List names of available recipes'
complete -c just -l variables -d 'List names of variables'
complete -c just -s h -l help -d 'Print help'
complete -c just -s V -l version -d 'Print version'
