function peek --description 'Show a compact tree inside the current Git project'
    if not command -q git
        log_error 'git is not installed.'
        return 1
    end

    if not command -q tree
        log_error 'tree is not installed.'
        return 1
    end

    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    if test -z "$root"
        log_error 'Not inside a Git repository.'
        return 1
    end

    set -l relative_path .
    set -l depth 2

    if test (count $argv) -ge 1
        set relative_path $argv[1]
    end

    if test (count $argv) -ge 2
        if not string match -qr '^[1-9][0-9]*$' -- $argv[2]
            log_error 'Depth must be a positive integer.'
            return 1
        end
        set depth $argv[2]
    end

    if test (count $argv) -gt 2
        log_error 'Usage: peek [path] [depth]'
        return 1
    end

    set -l target
    if string match -qr '^/' -- $relative_path
        set target (path resolve $relative_path)
    else
        set target (path resolve "$root/$relative_path")
    end

    if not string match -q "$root" "$target"; and not string match -q "$root/*" "$target"
        log_error 'Target must remain inside the current Git project.'
        return 1
    end

    if not test -d "$target"
        log_error "Directory not found: $relative_path"
        return 1
    end

    set -l display_path (path relative-to "$root" "$target")
    test -n "$display_path"; or set display_path .

    echo (set_color cyan)'◆ project peek'(set_color normal)
    echo '  root: '(set_color brblack)$root(set_color normal)
    echo '  path: '(set_color yellow)$display_path(set_color normal)
    echo

    tree -a -L $depth --dirsfirst \
        -I '.git|node_modules|.svelte-kit|build|dist|coverage' \
        "$target"
end
