#!/bin/bash
set -e
cd "$(dirname "$0")"

echo $(pwd)

MISSING=$(comm -13 <(code --list-extensions | sort) <(sort extensions.txt))

echo ${MISSING}

for p in $MISSING; do
  echo "code --force --install-extension $p"
  code --force --install-extension "$p"
done
