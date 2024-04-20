#!/usr/bin/env bash

# https://docs.fedoraproject.org/en-US/quick-docs/installing-plugins-for-playing-movies-and-music/
# https://docs.fedoraproject.org/en-US/quick-docs/rpmfusion-setup/

sudo dnf update -y
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf group update core -y
sudo dnf group install --allowerasing Multimedia -y
