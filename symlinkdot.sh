#!/bin/bash

files="bashrc vimrc vimperatorrc"

for file in $files; do
    ln -s "$PWD/$file" ~/.$file
done
