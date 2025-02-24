# play - initialize a playground with VCS set up
function play
    set dir (mktemp --directory)
    set remote "$dir/origin"
    set dir "$dir/playground"
    mkdir --parents $remote
    mkdir $dir

    cd $remote
    git init --bare

    cd $dir
    jj git init --colocate
    jj git remote add origin ../origin
    jj config set --repo "revset-aliases.'trunk()'" "present(main@origin)"
end
