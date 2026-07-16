function ghcreate --description 'Create a GitHub repository from the current project'
    set -l visibility private
    if test "$argv[1]" = "--public"
        set visibility public
        set -e argv[1]
    end

    set -l repo
    if test (count $argv) -ge 1
        set repo $argv[1]
    else
        set repo (basename (pwd))
    end

    gh auth status >/dev/null; or begin
        echo "Run: gh auth login"
        return 1
    end

    gh repo create "$repo"         --source=.         --remote=origin         --$visibility         --push
end
