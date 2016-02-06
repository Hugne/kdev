#!/bin/bash
#Don't fiddle with users .config if there is one already
if [ -f ./linux/.config ]; then
	echo "Using existing kernel config"
else
	make -C ./linux x86_64_defconfig
	sed -i '/^VIRTIO=/{h;s/=.*/=VIRTIO=y/};${x;/^$/{s//VIRTIO=y/;H};x}' ./linux/.config	
	sed -i '/^VIRTIO_NET=/{h;s/=.*/=VIRTIO_NET=y/};${x;/^$/{s//VIRTIO_NET=y/;H};x}' ./linux/.config
	sed -i '/^VIRTIO_PCI=/{h;s/=.*/=VIRTIO_PCI=y/};${x;/^$/{s//VIRTIO_PCI=y/;H};x}' ./linux/.config
fi
