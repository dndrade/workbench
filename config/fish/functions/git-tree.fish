function git-tree --description 'Show Git-tracked files as a tree'
    if not command -q git
        log_error 'git is not installed.'
        return 1
    end

    if not command -q tree
        log_error 'tree is not installed.'
        return 1
    end

    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        log_error 'Not inside a Git repository.'
        return 1
    end

    set -l root (git rev-parse --show-toplevel)
    set -l depth

    argparse 'L/depth=' -- $argv
    or begin
        echo 'Usage: git-tree [--depth N]'
        return 2
    end

    if test (count $argv) -gt 0
        log_error 'Usage: git-tree [--depth N]'
        return 2
    end

    set -l tmpfile (mktemp)
    or return 1

    command git -C "$root" ls-files > "$tmpfile"

    set -l tree_args --fromfile --dirsfirst
    if set -q _flag_depth
        if not string match -qr '^[1-9][0-9]*$' -- $_flag_depth
            rm -f "$tmpfile"
            log_error 'Depth must be a positive integer.'
            return 2
        end
        set -a tree_args -L $_flag_depth
    end

    echo (set_color cyan)'◆ tracked files'(set_color normal)"  $root"
    tree $tree_args "$tmpfile"
    set -l result $status
    rm -f "$tmpfile"
    return $result
end
