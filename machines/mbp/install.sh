#!/bin/bash

set -xe

mkdir -p ~/.ssh
chmod 700 ~/.ssh

if [ ! -f ~/.ssh/id_ed25519 ]; then
  ssh-keygen -f ~/.ssh/id_ed25519
fi

BREW=$(which brew)
ret=$?

if [ $ret -ne 0 ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

fi

brew install --cask ghostty
brew install --cask firefox
brew install --cask 1password
brew install coreutils divvy git git-gui kdiff3 fzf ripgrep stow zoxide pkg-config gnutls libsvg libpng libxpm jpeg librsvg imagemagick webp freetype tree-sitter libgccjit libtiff texinfo

echo "Setup git access now please"
read
ssh-add -L

cd && mkdir -p workspace

if [ -d workspace/dotfiles ]; then
  exit 0;
fi

pushd workspace
git clone git@github.com:ebittleman/dotfiles.git
cd dotfiles
chmod +x install.sh 

./install.sh
popd

