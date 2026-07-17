# Portable aliases for project development inside the container.

if command -q git
    alias gst='git status'
    alias ga='git add'
    alias gau='git add -u'
    alias gaa='git add --all'
    alias gcm='git commit -m'
    alias gca='git commit --amend'
    alias gsw='git switch'
    alias gswc='git switch -c'
    alias gl='git log --oneline --graph --decorate --all'
    alias gcl='git clone'
    alias gd='git diff'
    alias gds='git diff --staged'
    alias gls='git ls-files'
    alias gt='git tag'
    alias gr='git restore'
    alias grs='git restore --staged'
    alias gpl='git pull'
    alias gps='git push'
    alias gpt='git push --tags'
    alias gbr='git branch'
    alias gbrd='git branch -d'
    alias gbs='git branch -a'
    alias gup='git fetch --all --prune; and git pull --rebase'
    alias ghp='git push origin (git branch --show-current)'
    alias ghpr='git pull origin (git branch --show-current)'
end

if command -q gh
    alias ghcl='gh repo clone'
    alias ghu='gh repo view --web'
    alias ghprc='gh pr create'
    alias ghprv='gh pr view --web'
end

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias df='df -h'
alias du='du -sh'
alias grep='grep --color=auto'
alias e='exit'
alias reload='exec fish'

if command -q vim
    alias vi='vim'
end

alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
