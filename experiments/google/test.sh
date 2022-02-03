#!/usr/bin/env bash
set -eu

INSTANCES="n1"
ROOT=/Users/suderman/Workspaces/JHU
ANVIL=$ROOT/anvil
PROFILE=~/.abm/profile.yml

function rewrite() {
    cat $PROFILE | sed "s|$1|$2|" > /tmp/profile.yml
    rm $PROFILE
    mv /tmp/profile.yml $PROFILE
}

for i in $INSTANCES ; do
    key=$(abm $i user key alex@fake.org)
    rewrite "__KEY__" $key
    abm $i workflow upload workflows/dna-cloud-costs.ga
    abm $i history import dna
    abm $i history import rna
done