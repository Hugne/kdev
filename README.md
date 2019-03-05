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
	    server_args     = /home/dude/kdev/sys/boot
	    disable         = no
    }
```

And start/restart xinetd
```shell
    $ sudo service xinetd start
```
It's also possible to run tftpd as a systemd service.

BOOTING
-------
9pm is used to configure virsh network and start domains, check out Richard's repo
https://github.com/rical/9pm
There are two ways to run the 9pm scripts ether invoke the .tcl scripts directly, for this you need to define the TCLLIBPATH environment variable:
```
    $ export TCLLIBPATH=/home/dude/kdev/test/9pm
    $ test/cases/net_start.tcl
      2016 02 04 - 21:03:39 - 1..2
      2016 02 04 - 21:03:39 - # INFO - Network default is not defined
      2016 02 04 - 21:03:39 - ok 1 - Network defined from virsh/default.xml
      2016 02 04 - 21:03:39 - ok 2 - Network default started

```
Or you can invoke them through the 9pm harness.
```shell
    $ 9pm/9pm.pl cases/net_start.tcl
      net_start.tcl ..
      1..2
      # INFO - Network default is not defined
      ok 1 - Network defined from virsh/default.xml
      ok 2 - Network default started
      ok
      All tests successful.
      Files=1, Tests=2, 0.946269 wallclock secs ( 0.02 usr  0.00 sys +  0.05 cusr  0.01 csys =  0.08 CPU)
      Result: PASS
```


A couple of simple scripts are provided, to start/stop the virsh network, and VM.
Starting the VM requires that you pass a configuration file, which tells 9pm what template virsh XML it should use to define the domain, the IP, hostname etc.

Two minimal suites are also provided to bring up/tear down the network and VM, this is run using the harness:
```shell
    $ 9pm/9pm.pl -v start.yaml -c conf/node1.yaml 
      start/net_start.tcl ...
      1..2
      # INFO - Network default is not defined
      ok 1 - Network defined from virsh/default.xml
      ok 2 - Network default started
      ok
      start/node_start.tcl ..
      1..3
      ok 1 - Domain defined from /tmp/node.xml.gcmfdtbx
      ok 2 - Domain node1 started
      # INFO - No echo reply from node1, still trying
      # INFO - No echo reply from node1, still trying
      ok 3 - Echo reply from node1
      ok
      All tests successful.
      Files=2, Tests=5, 8.26454 wallclock secs ( 0.03 usr  0.01 sys +  0.07 cusr  0.04 csys =  0.15 CPU)
      Result: PASS
```
Attach to the domain with
```
    $ virsh console node1
```

DEVELOPMENT
-----------
After any code is changed in a repo that is to be installed in rootfs/built into the initramfs, 
you need to invoke make and make install in the top level directory. This will rebuild any changed
files and generate a new initramfs.

There's an SMB share entry in the kdev nodes fstab.
To make this work, install samba on the host system and add a share entry
to the end of /etc/samba/smb.conf and restrict access to the kdev network.
Then restart samba with `systemctl restart smbd`
```
[share]
path = /home/dude/kdev/
guest ok = yes
read only = yes
hosts allow = 192.168.100.0/255.255.255.0
```

TODO
--------
- dropbear dependencies to libnss..
- install target script that copies binarys from host machine to rootfs, run before copylibs.sh
- doc from toplevel Makefile.am should be placed in rootfs, not in $(prefix)/share
