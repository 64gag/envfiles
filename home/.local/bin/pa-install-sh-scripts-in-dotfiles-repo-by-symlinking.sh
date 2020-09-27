#!/usr/bin/env bash

cd ~/git/dotfiles/home/.local/bin/
dir_script=$(pwd)

chmod +x *.sh
ln -sf $dir_script/*.sh ~/.local/bin/
