#!/usr/bin/env bash

for i in n1 n2 c2 e2 ; do
	echo "Updating $i"
	KUBECONFIG=~/.kube/configs/$i helm upgrade -n galaxy galaxy anvil/galaxykubeman --reuse-values -f values.yml
done
echo "Done"