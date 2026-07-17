function sshwho --description 'Inspect forwarded SSH-agent availability and identities'
    if not command -q ssh-add
        log_error 'ssh-add is not installed.'
        return 1
    end

    echo (set_color cyan)'◆ ssh agent'(set_color normal)

    if not set -q SSH_AUTH_SOCK; or test -z "$SSH_AUTH_SOCK"
        log_warn 'SSH_AUTH_SOCK is not set.'
        echo 'The host SSH agent has not been forwarded into this container.'
        return 1
    end

    echo "socket: $SSH_AUTH_SOCK"

    if not test -S "$SSH_AUTH_SOCK"
        log_error 'SSH_AUTH_SOCK does not point to a socket.'
        return 1
    end

    ssh-add -l
    switch $status
        case 0
            log_ok 'Forwarded SSH agent is available.'
        case 1
            log_warn 'SSH agent is available but contains no identities.'
        case '*'
            log_error 'Could not communicate with the forwarded SSH agent.'
            return 1
    end
end
