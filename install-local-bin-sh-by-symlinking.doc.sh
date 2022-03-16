#!/usr/bin/env bash

mkdir -p ~/.local/bin/

# TODO Make sure this script is executed from a given location

loop_dir=home/.local/bin
for i in ${loop_dir}/*.sh; do
    if [ -f $i ]; then
        chmod +x $i
        ln -s "$(pwd)/$i" ~/.local/bin/
    fi
done
