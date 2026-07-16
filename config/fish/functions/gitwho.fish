function gitwho --description 'Show Git, SSH and GitHub authentication status'
    echo "Git:"
    git config --get user.name
    git config --get user.email
    echo

    echo "SSH Agent:"
    if test -n "$SSH_AUTH_SOCK"
        echo "✓ Forwarded ($SSH_AUTH_SOCK)"
    else
        echo "✗ No SSH agent detected"
    end
    echo

    echo "GitHub CLI:"
    if command -q gh
        gh auth status
    else
        echo "gh CLI not installed"
    end
end
