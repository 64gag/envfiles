#!/usr/bin/env bash

cd ~/git/dotfiles/home/.local/bin/
dir_script=$(pwd)

chmod +x *.sh
mkdir ~/.local/bin/
ln -sf $dir_script/*.sh ~/.local/bin/
