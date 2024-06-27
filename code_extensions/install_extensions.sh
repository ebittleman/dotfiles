#!/bin/bash
set -e
cd "$(dirname "$0")"

MISSING=$(comm -13 <(sort extensions.txt) <(code --list-extensions | sort))

if [ ! -z "${MISSING}" ]; then
while IFS= read -r p; do
	echo "code --install-extension ${p}"
	code --install-extension ${p}
done <<< ${MISSING}
fi

