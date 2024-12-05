@_default:
    just --list --unsorted

# chezmoi apply the current state of the jj repo
apply:
    chezmoi git checkout $(jj log --no-graph -r @ -T commit_id)
    @git reset --soft HEAD^ # make sure HEAD points to @-
    chezmoi apply
    @jj git export # not necessary but nice

syncthing-server-ui:
    #!/bin/bash
    set -emo pipefail # -m to enable job control
    echo Alright, gimme one second...
    ssh -N -L 9090:127.0.0.1:8384 pi || true && echo &
    sleep 2 && xdg-open http://localhost:9090
    fg # bring ssh session to foreground
