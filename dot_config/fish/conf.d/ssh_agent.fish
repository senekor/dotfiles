# When we're ssh'ed onto a server, the SSH_AUTH_SOCK variable is already set
# by the agent forwarding. In that case, we shouldn't overwrite it, because
# 1Password is not running on servers.
if test -z "$SSH_AUTH_SOCK"
    set --global --export SSH_AUTH_SOCK ~/.1password/agent.sock
end
