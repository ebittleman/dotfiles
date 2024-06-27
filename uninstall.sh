#!/bin/sh

set -e

CACHE_DIR=${XDG_CACHE_HOME:-$HOME/.cache}
if [[ "$OSTYPE" == "linux"* ]]; then
    CODE_TARGET="${CACHE_DIR}"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    CODE_TARGET="${HOME}/Library/Application Support"
fi

set -x

stow -v --target="${CODE_TARGET}/Code/User" --delete code
stow -v --target=$HOME --delete zsh
stow -v --target=$HOME --delete p10k
stow -v --target=$HOME --delete emacs
