AM_MAKEFLAGS="PROGRAMS=dropbear dbclient dropbearkey dropbearconvert scp"
SUBDIRS = dropbear

install-exec-local:
	mkdir -p $(prefix)/rootfs/etc/dropbear/
	[ -f $(prefix)/rootfs/etc/dropbear/dropbear_ecdsa_host_key ] && echo "SSH host key already exists" || dropbear/dropbearkey -t ecdsa -s 256 -f $(prefix)/rootfs/etc/dropbear/dropbear_ecdsa_host_key
	mkdir -p $(prefix)/rootfs/root/.ssh/
	cat ~/.ssh/id_rsa.pub > $(prefix)/rootfs/root/.ssh/authorized_keys
