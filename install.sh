#!/bin/bash

set -e

cd "$(dirname "$0")"

CACHE_DIR=${XDG_CACHE_HOME:-$HOME/.cache}
if [ "$OSTYPE" == "linux-gnu" ]; then
    CODE_TARGET="${CACHE_DIR}"
elif [ "$OSTYPE" == "darwin"* ]; then
    CODE_TARGET="${HOME}/Library/Application Support"
else
	echo "Unsupported OS: ${OSTYPE}"
	exit 1
fi

set -x

stow -v --target=${HOME} --restow emacs
stow -v --target=${HOME} --restow p10k
stow -v --target=${HOME} --restow zsh
mkdir -p ${CODE_TARGET}/Code/User
stow -v --target="${CODE_TARGET}/Code/User" --restow code

if [ -f "$(which code)" ]; then
chmod +x code_extensions/install_extensions.sh
code_extensions/install_extensions.sh
fi

chmod +x precommit-hook.sh
mkdir -p .git/hooks
cp precommit-hook.sh .git/hooks/pre-commit
