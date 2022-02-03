#!/usr/bin/env bash

INSTANCES="n1 n2 c2 e2"

for i in $INSTANCES ; do
	echo "Cleaning up $i"
	(source settings/$i && ./provision.sh cleanup)
done
echo "Done"