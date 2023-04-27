#!/usr/bin/env bash

if [[ $# = 0 ]] ; then
	echo "No rules file provided"
	exit 1
fi

if [[ ! -e $1 ]] ; then
	echo "Unable to find the values file $1"
	exit 1
fi

chart=/Users/suderman/Workspaces/JHU/galaxykubeman-helm/galaxykubeman
name=gkm
namespace=gkmns

echo "Upgrading with values from $1"
helm upgrade $name --namespace $namespace $chart --reset-values -f values.yml -f $1

