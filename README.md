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
--------
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

BOOTING
-------
9pm is used to configure virsh network and start domains, check out Richard's repo
https://github.com/rical/9pm
In order to run 9pm scripts, you need to define the TCLLIBPATH environment variable.
```
    export TCLLIBPATH=/home/dude/kdev/test/9pm
```
Two simple scripts are provided, to start the virsh network, and to start a VM.
Starting the VM requires that you pass a configuration file, which tells 9pm what
template virsh XML it should use to define the domain, the IP, hostname etc.

```shell
    $ ./net.tcl
    $ ./node.tcl -c virsh.yaml
```
Attach to the domain with
```
    $ virsh console node1
```
TODO
--------
Add 9pm VM start scripts and examples

