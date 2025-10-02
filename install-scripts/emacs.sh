#!/bin/bash

set -xe

curl -o emacs-30.1.tar.gz https://mirrors.ocf.berkeley.edu/gnu/emacs/emacs-30.1.tar.gz
tar xzf emacs-30.1.tar.gz
cd emacs-30.1
./configure --with-native-compilation=aot
make
make install
