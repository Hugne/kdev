!/bin/bash
#Hack to append /rootfs to the prefix path
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

cd ethtool
./autogen.sh
./configure $args

