#!/usr/bin/env bash

#QUERIES="numjobs history_runtimes"
QUERIES="all_history_runtimes"

if [[ ! -e $1.sh ]] ; then
	echo "ERROR: No such configuration. Should be one of jetstream.sh, aws.sh, or gcp.sh"
	exit 1
fi

source ./$1.sh

if [[ ! -e $KUBECONFIG ]] ; then
	echo "ERROR: kubeconfig $KUBECONFIG not found."
	exit 1
fi

for query in $QUERIES ; do
	kubectl exec -in $NAMESPACE $POD -- sudo -u postgres psql -d galaxy --csv < sql/$query.sql > results/$1-$query.csv
done
