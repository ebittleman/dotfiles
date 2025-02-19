#!/bin/bash

set -ex

export DEBIAN_FRONTEND=noninteractive

PKGS=('emacs' 'vim' 'ripgrep' 'zsh' 'stow' 'fzf' 'stow' 'gnome-firmware' 'podman' 'btop' 'htop')

# starlabs
if [ ! -f "/etc/apt/sources.list.d/starlabs-main-noble.list"]; then
  add-apt-repository -y ppa:starlabs/main
  add-apt-repository -y universe
fi
PKGS+=('fwupd')
PKGS+=('libflashrom1')

# 1password

if [ ! -f "/usr/share/keyrings/1password-archive-keyring.gpg" ]; then
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
fi

if [ ! -f "/etc/apt/sources.list.d/1password.list" ]; then
   echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | tee /etc/apt/sources.list.d/1password.list
fi

if [ ! -d "/etc/debsig/policies/AC2D62742012EA22/" ]; then
  mkdir -p /etc/debsig/policies/AC2D62742012EA22/
  curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
fi

if [ ! -d "/usr/share/debsig/keyrings/AC2D62742012EA22" ]; then
  mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
fi
PKGS+=('1password')


apt-get update
apt-get install -y ${PKGS[@]}

