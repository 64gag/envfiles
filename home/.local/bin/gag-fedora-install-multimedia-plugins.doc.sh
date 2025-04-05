#!/usr/bin/env bash

# https://docs.fedoraproject.org/en-US/quick-docs/installing-plugins-for-playing-movies-and-music/
# https://docs.fedoraproject.org/en-US/quick-docs/rpmfusion-setup/

sudo dnf -y update
sudo dnf -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf -y group update core
sudo dnf -y group install --allowerasing multimedia
