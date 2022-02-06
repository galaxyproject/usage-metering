#!/usr/bin/env bash
set -eu

INSTANCES=${INSTANCES:-n1 n2 c2 e2}
PROFILE=~/.abm/profile.yml

function rewrite() {
    cat $PROFILE | sed "s|$1|$2|" > /tmp/profile.yml
    rm $PROFILE
    mv /tmp/profile.yml $PROFILE
}

for i in $INSTANCES ; do
    echo "Provisioning $i"
    (source settings/$i && ./provision.sh disk cluster galaxy)
    cat >> $PROFILE << EOF
$i:
  url: __URL__
  key: __KEY__
  kube: ~/.kube/configs/$i 
EOF
    url=$(abm $i kube url)
    rewrite "__URL__" $url
    curl $url
    key=$(abm $i user key alex@fake.org)
    rewrite "__KEY__" $key
    echo "Bootstrapping $i"
    abm $i workflow upload workflows/dna-cloud-costs.ga
    abm $i history import dna
    #abm $i history import rna
done

#abm experiment run experiment.yml

# TODO Cleanup instances