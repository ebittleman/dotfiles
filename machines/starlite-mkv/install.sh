#!/bin/bash

set -ex

DIR=$(dirname "$(realpath $0)")

sudo ${DIR}/software.sh
flatpak install -y \
  flathub md.obsidian.Obsidian \
  flathub com.plexamp.Plexamp

sudo chsh -s $(which zsh) ${USER}

