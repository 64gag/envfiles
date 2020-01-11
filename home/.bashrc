# Source this file at the bottom of ~/.bashrc
# source ~/git/dotfiles/home/.bashrc

alias v='vim'
alias g='git'
alias r='rails'
alias t='gnome-terminal'
alias psc='ps xawf -eo pid,user,cgroup,args'
alias cmakedebug='cmake $1 -DCMAKE_BUILD_TYPE=DEBUG'
alias cmakerelease='cmake $1 -DCMAKE_BUILD_TYPE=RELEASE'

# Jump in history with up and down arrow
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

export PATH="$PATH:$HOME/.local/bin"

if [ -f  ~/.rvm/scripts/rvm ]; then
    export PATH="$PATH:$HOME/.rvm/bin"
    source ~/.rvm/scripts/rvm
fi
