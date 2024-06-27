#!/bin/sh

set -e
cd "$(dirname "$0")/../.."

if [ -f "$(which code)" ]; then
	set -x
	code --list-extensions | sort > ./code_extensions/extensions.txt
	git add ./code_extensions/extensions.txt
fi
