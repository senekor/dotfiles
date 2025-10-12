function bgi --description "bgi <name>"
    set repo $argv[1]
    # TODO: assert repo doesn't contain path separator
    set path ~/repos/buenzli/$repo

    mkdir --parents $path
    cd $path

    jj git init
    jj git remote add origin buenzli:remo/$repo
    jj config set --repo "revset-aliases.'trunk()'" "present(main@origin)"

    ide
end
