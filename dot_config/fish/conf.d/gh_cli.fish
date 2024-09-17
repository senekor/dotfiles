if status is-interactive
    function gh --wraps gh --description 'gh alias with auth token'
        set --export GH_TOKEN "$(op read "op://Personal/GitHub Personal Access Token/token")"
        command gh $argv
    end
    function ghz --wraps gh --description 'gh alias with auth token for zhaw'
        set --export GH_HOST "github.zhaw.ch"
        set --export GH_ENTERPRISE_TOKEN "$(op read "op://InES/GitHub Personal Access Token/token")"
        command gh $argv
    end
end
