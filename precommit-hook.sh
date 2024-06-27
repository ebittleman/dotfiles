#!/bin/sh

set -xe
cd "$(dirname "$0")/../.."

code --list-extensions | sort > ./code_extensions/extensions.txt

git add ./code_extensions/extensions.txt
