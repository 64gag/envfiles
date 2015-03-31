#!/bin/bash

files="bashrc vimrc vimperatorrc"

for file in $files; do
    ln -s ~/dotfiles/$file ~/.$file
done
