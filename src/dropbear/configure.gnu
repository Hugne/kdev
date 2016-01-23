#!/bin/bash
#Hack to append /rootfs to the prefix path
#to make dropbear install there, and not the root directly
args=()
for arg in "$@"
do
    case "$arg" in
    --prefix=*)
	arg+=/rootfs
       ;;
    *) ;;
    esac
    args+=$arg
    args+=" "
done

cd dropbear
autoconf
autoheader
./configure $args
