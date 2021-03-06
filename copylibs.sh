#!/bin/bash

#Find all executables under $1 and copy required libs
#from host to $1
FILES=$(find $1 -executable -type f)
LIBS=""
#Check which libs are used by each executable
for f in $FILES; do 
LIBS+=$(/usr/bin/ldd $f |awk '{print $1"\n"$3"\n"}')
done
#Remove duplicate libs
LLI=$( awk 'BEGIN{RS=ORS=" "}!a[$0]++' <<<$LIBS );

#Make sure ld-linux is included
LLI="${LLI[@]} `find /lib -name ld-linux-*`"

#Add extra deps for dropbear
LLI="${LLI[@]} `find /lib -name libnss_compat.so* -o -name libnss_nis.so* -o -name libnss_files.so* -o -name libnsl.so*`"

#Copy to $1/lib
for lib in $LLI; do
	if [ -e $lib ]
	then
		echo "Add $lib to rootfs/lib/"
		cp -f $lib $1/lib/
	fi
done
ln -r -s -f $1/lib $1/lib64

