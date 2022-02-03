#!/usr/bin/env bash

#QUERIES="numjobs history_runtimes"
QUERIES="all_history_runtimes"

if [[ ! -e results ]] ; then
	echo "Making output directory"
	mkdir results
fi

for cloud in js aws gcp ; do
  source ./$cloud.sh
  for query in $@ ; do
    echo "Running $query on $cloud"
	  kubectl exec -in $NAMESPACE $POD -- sudo -u postgres psql -d galaxy --csv < sql/$query.sql > results/$cloud-$query.csv
	done
done
