function fish_greeting --description 'Show a compact Workbench startup summary'
    set -l project 'no-project'
    set -l branch

    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    if test -n "$root"
        set project (basename "$root")
        set branch (git branch --show-current 2>/dev/null)
    end

    set -l ssh_status 'ssh:off'
    if set -q SSH_AUTH_SOCK; and test -S "$SSH_AUTH_SOCK"
        set ssh_status 'ssh:on'
    end

    set -l gh_status 'gh:off'
    if command -q gh; and gh auth status >/dev/null 2>&1
        set gh_status 'gh:on'
    end

    echo (set_color cyan)'◆ workbench'(set_color normal)"  $project" \
        (test -n "$branch"; and echo " [$branch]"; or echo '')"  $ssh_status  $gh_status"
    echo '  fa aliases · fw workflows · peek [path] [depth]'
end
