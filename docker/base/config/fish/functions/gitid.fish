function gitid --description 'Inspect or set repository-local Git identity'
    if test (count $argv) -eq 2
        git config --local user.name "$argv[1]"
        git config --local user.email "$argv[2]"
        echo "Repository-local identity updated."
        return
    end

    echo "Git Identity"
    echo "------------"
    git config --show-origin --get user.name 2>/dev/null
    git config --show-origin --get user.email 2>/dev/null
end
