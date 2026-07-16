function gcleanb --description 'Delete local Git branches whose upstream is gone'
    if not command -q git
        log_error 'git is not installed.'
        return 1
    end

    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        log_error 'Not inside a Git repository.'
        return 1
    end

    git fetch --prune; or return 1

    set -l gone_branches (git for-each-ref --format='%(refname:short) %(upstream:track)' refs/heads \
        | string match -r '^\S+ \[gone\]$' \
        | string replace -r ' \[gone\]$' '')

    if test (count $gone_branches) -eq 0
        log_ok 'No gone branches to clean.'
        return 0
    end

    echo (set_color yellow)'Branches with deleted upstreams:'(set_color normal)
    printf '  %s\n' $gone_branches
    read -l -P 'Delete these local branches? [y/N] ' confirmation

    if not string match -qi 'y' -- $confirmation; and not string match -qi 'yes' -- $confirmation
        log_info 'Cancelled.'
        return 0
    end

    for branch in $gone_branches
        git branch -d -- $branch; or log_warn "Could not safely delete $branch"
    end
end
