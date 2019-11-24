#!/usr/bin/env bash

dir_script=$(realpath $(dirname "$0"))

cd "$dir_script"

chmod +x *.sh
ln -s $dir_script/pa-*.sh ~/.local/bin/
