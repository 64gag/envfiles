# Source this file at the bottom of ~/.bashrc
# source ~/git/dotfiles/home/.bashrc

alias v='vim'
alias g='git'
alias r='rails'
alias t='gnome-terminal'

export PATH="$PATH:$HOME/.local/bin"

if [ -f  ~/.rvm/scripts/rvm ]; then
    export PATH="$PATH:$HOME/.rvm/bin"
    source ~/.rvm/scripts/rvm
fi
