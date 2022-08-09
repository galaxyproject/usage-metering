#!/usr/bin/env bash

if [[ -z $KUBECONFIG && ! -e $HOME/.kube/config ]] ; then
	echo "The kubectl program does not apprear to be configured correctly."
	echo "You can download the required kubeconfig file from Rancher and rename"
	echo "to $HOME/.kube/config."
	exit 1
fi

OPTS=
if [[ $1 = -c || $1 = --csv ]] ; then
  OPTS='--csv'
  shift
fi

if [[ -z $1 ]] ; then
	echo "No SQL query provided."
	exit 1
fi

if [[ ! -e $1 ]] ; then
	echo "Unable to find $1"
	exit 1
fi

# Note the pod name will change anytime the postgres operator is restarted.
# POD=$(kubectl get pods -n initial | grep postgres | cut -d\  -f1)

# But this will be faster if we know the pod hasn't been restarted
POD=galaxy-galaxy-1626291120-galaxy-postgres-0
kubectl exec -in initial $POD -- sudo -u postgres psql -d galaxy $OPTS < $1
