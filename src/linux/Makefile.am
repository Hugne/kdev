AM_MAKEFLAGS = INSTALL_PATH=$(prefix)/../boot INSTALL_MOD_PATH=$(prefix) INSTALL_HDR_PATH=$(prefix) INSTALLKERNEL=null
SUBDIRS = linux

install-exec-local:
	echo "Install kernel modules in $(prefix)"
	INSTALL_MOD_PATH=$(prefix) make -C linux modules_install
