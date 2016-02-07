#!/bin/bash
#Don't fiddle with users .config if there is one already
if [ -f ./linux/.config ]; then
	echo "Using existing kernel config"
else
	make -C ./linux x86_64_defconfig
	sed -i '/^CONFIG_VIRTIO=/{h;s/=.*/=CONFIG_VIRTIO=m/};${x;/^$/{s//CONFIG_VIRTIO=m/;H};x}' ./linux/.config
	sed -i '/^CONFIG_VIRTIO_NET=/{h;s/=.*/=CONFIG_VIRTIO_NET=m/};${x;/^$/{s//CONFIG_VIRTIO_NET=m/;H};x}' ./linux/.config
	sed -i '/^CONFIG_VIRTIO_PCI=/{h;s/=.*/=CONFIG_VIRTIO_PCI=m/};${x;/^$/{s//CONFIG_VIRTIO_PCI=m/;H};x}' ./linux/.config
fi
