kdev
=============================

kdev is a Linux kernel development and testing environment.
It does not aim to be anything else, which is why you will see
some weird stuff as copying libs from the host system directly
into the initramfs. This is to make portability between the host
build system/test VM as easy as possible.


Installation
------------
```shell
    $ ./autogen.sh
    $ ./configure
    $ make
    $ sudo make install
```
The default install prefix is /tmp, which means that
the rootfs and pxe boot directory will be placed there.
This can be changed using the normal autotools --prefix, e.g:
```shell
    $./configure --prefix=/home/dude/kdev/sys 
```

TFTPBOOT
--------------
You'll need to configure a tftp server and point tftproot
to the 'boot' directory under your prefix.
```shell
    $ sudo apt install tftpd
```
To run tftpd as an xinetd service, add the file /etc/xinetd.d/tftp 
with the following contents (change the server\_args path
```shell
    service tftp
    {
 	    protocol        = udp
	    port            = 69
	    socket_type     = dgram
	    wait            = yes
	    user            = nobody
	    server          = /usr/sbin/in.tftpd
	    server_args     = /home/dude/kdev/sys
	    disable         = no
    }
```

And start/restart xinetd
```shell
    $ sudo service xinetd start
```

TODO
--------
Add 9pm VM start scripts and examples

