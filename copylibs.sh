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
#Copy to $1/lib
for lib in $LLI; do
	if [ -e $lib ]
	then
		echo $lib
		cp -f $lib $1/lib/
	fi
done

ln -r -s -f $1/lib $1/lib64

