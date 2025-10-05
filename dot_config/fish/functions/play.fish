# play - initialize a playground with VCS set up
function play
    set dir (mktemp --directory)
    trap "rm -rf $dir" EXIT
    set remote "$dir/origin"
    set dir "$dir/playground"
    mkdir --parents $remote
    mkdir $dir

    cd $remote
    git init --bare

    cd $dir
    jj git init
    jj --ignore-working-copy git remote add origin ../origin
    jj --ignore-working-copy config set --repo "revset-aliases.'trunk()'" "present(main@origin)"
    jj --ignore-working-copy config set --repo "revset-aliases.'immutable_heads()'" "root()"
    jj --ignore-working-copy config set --repo "revsets.log" "all()"
    jj --ignore-working-copy config set --repo "git.sign-on-push" false

    jj --ignore-working-copy bookmark create main --revision @
    jj --ignore-working-copy commit --message "initial commit"
    jj --ignore-working-copy git push --bookmark main
end
