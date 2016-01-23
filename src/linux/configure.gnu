#!/bin/sh
#Don't fiddle with users .config if there is one already
[ -f ./linux/.config ] && echo "Using existing kernel config" || make -C ./linux x86_64_defconfig
