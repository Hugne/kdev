AM_MAKEFLAGS = INSTALL_PATH=$(prefix)/boot INSTALL_MOD_PATH=$(prefix)/rootfs INSTALL_HDR_PATH=$(prefix)/rootfs INSTALLKERNEL=null
SUBDIRS = linux

install-exec-local:
	echo "Install kernel modules in $(prefix)/rootfs"
	INSTALL_MOD_PATH=$(prefix)/rootfs make -C linux modules_install
