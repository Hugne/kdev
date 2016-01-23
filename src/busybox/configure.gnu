#!/bin/sh
#Don't fiddle with users .config if there is one already
if [ -f ./busybox/.config ]; then
	echo "Using existing busybox config"
else
	make -C ./busybox defconfig
fi
#But busybox have a stupid CONFIG_PREFIX knob that we have to change
#at this stage
for arg in "$@"
do
    case "$arg" in
    --prefix=*)
	prefix=${arg#*=}/rootfs
	break
       ;;
    *) ;;
    esac
done
sed -i '/CONFIG_PREFIX/d' busybox/.config
echo CONFIG_PREFIX=\"$prefix\" >> ./busybox/.config
exit 0
