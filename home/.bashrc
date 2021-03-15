# Add to the bottom of ~/.bashrc
# source ~/git/dotfiles/home/.bashrc

vimw() { local _lang=$1; shift; vim --cmd "let _lang='${_lang}'" $@; }

# https://www.atlassian.com/git/tutorials/dotfiles
#alias cfgit='/usr/bin/git --git-dir=$HOME/git/dotfiles/.git --work-tree=$HOME'

alias psc='ps xawf -eo pid,user,cgroup,args'
alias cmakedebug='cmake $1 -DCMAKE_BUILD_TYPE=DEBUG'
alias cmakerelease='cmake $1 -DCMAKE_BUILD_TYPE=RELEASE'
alias vimp='vim -u NONE -c "helptags doc" -c q'

# Jump in history with up and down arrow
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

export DEBEMAIL="paguiar@protonmail.com"
export PATH="$PATH:$HOME/.local/bin"
export EDITOR=vim

if [ -f  ~/.rvm/scripts/rvm ]; then
    export PATH="$PATH:$HOME/.rvm/bin"
    source ~/.rvm/scripts/rvm
fi
