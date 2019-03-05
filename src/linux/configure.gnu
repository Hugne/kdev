#!/bin/bash
#Don't fiddle with users .config if there is one already
if [ -f ./linux/.config ]; then
	echo "Using existing kernel config"
else
	make -C ./linux x86_64_defconfig
	sed -i '/^CONFIG_VIRTIO=/{h;s/=.*/=CONFIG_VIRTIO=m/};${x;/^$/{s//CONFIG_VIRTIO=m/;H};x}' ./linux/.config
	sed -i '/^CONFIG_VIRTIO_NET=/{h;s/=.*/=CONFIG_VIRTIO_NET=m/};${x;/^$/{s//CONFIG_VIRTIO_NET=m/;H};x}' ./linux/.config
	sed -i '/^CONFIG_VIRTIO_PCI=/{h;s/=.*/=CONFIG_VIRTIO_PCI=m/};${x;/^$/{s//CONFIG_VIRTIO_PCI=m/;H};x}' ./linux/.config
	sed -i '/^CONFIG_BRIDGE=/{h;s/=.*/=CONFIG_BRIDGE=m/};${x;/^$/{s//CONFIG_BRIDGE=m/;H};x}' ./linux/.config
	sed -i '/^CONFIG_CIFS=/{h;s/=.*/=CONFIG_CIFS=m/};${x;/^$/{s//CONFIG_CIFS=m/;H};x}' ./linux/.config
	sed -i '/^CONFIG_VETH=/{h;s/=.*/=CONFIG_VETH=m/};${x;/^$/{s//CONFIG_VETH=m/;H};x}' ./linux/.config
	sed -i '/^CONFIG_TIPC=/{h;s/=.*/=CONFIG_TIPC=m/};${x;/^$/{s//CONFIG_TIPC=m/;H};x}' ./linux/.config
	sed -i '/^CONFIG_TIPC_MEDIA_UDP=/{h;s/=.*/=CONFIG_TIPC_MEDIA_UDP=y/};${x;/^$/{s//CONFIG_TIPC_MEDIA_UDP=y/;H};x}' ./linux/.config





fi
