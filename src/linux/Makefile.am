PXEBOOT=$(prefix)/boot/
ROOTFS=$(prefix)/rootfs/
ROOTFS_BOOT=$(ROOTFS)/boot
AM_MAKEFLAGS = INSTALL_PATH=$(ROOTFS_BOOT) INSTALL_MOD_PATH=$(ROOTFS) INSTALL_HDR_PATH=$(ROOTFS) INSTALLKERNEL=null

SUBDIRS = linux

install-exec-local:
	ln -s -r -b $(ROOTFS_BOOT)/vmlinuz $(PXEBOOT)/vmlinuz
	echo "Install kernel modules in $(prefix)/rootfs"
	INSTALL_MOD_PATH=$(prefix)/rootfs make -C linux modules_install
	INSTALL_HDR_PATH=$(ROOTFS) make -C linux headers_install
