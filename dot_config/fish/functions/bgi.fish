# bgi - BuenzliGit init
#
# A simple function for initializing repositories.

function bgi
    if set --query argv[1]
        set name $argv[1]
        if string match '/*' $name
            cd $name
        else
            mkdir ~/repos/$name && cd ~/repos/$name
        end
    else
        set name (basename $PWD)
    end

    jj git init --colocate

    jj git remote add origin "git@git.buenzli.dev:remo/$name"

    jj bookmark create main --revision 'root()'
end
