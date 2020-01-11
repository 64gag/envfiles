#!/usr/bin/env bash

cd $(dirname $0)
dir_script=$(pwd)

chmod +x *.sh
ln -s $dir_script/*.sh ~/.local/bin/
