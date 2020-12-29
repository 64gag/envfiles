# Add to the bottom of ~/.bashrc
# source ~/git/dotfiles/home/.bashrc

vimw() { local _lang=$1; shift; vim --cmd "let _lang='${_lang}'" $@; }

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
