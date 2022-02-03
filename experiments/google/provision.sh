#!/usr/bin/env bash

set -eu

YEAR=$(($(date +%Y)-2000))

export IMAGE=${IMAGE:-galaxy/galaxy-min}
export TAG=${TAG:-21.05}
export GKE_VERSION=${GKE_VERSION:-1.19}
export ZONE=${ZONE:-us-east1-b}
export CHART=${CHART:-anvil/galaxykubeman}
export GKM_VERSION=${GKM_VERSION:-1.1.0}
export PASSWORD=${PASSWORD:-galaxypassword}
export EMAIL=${EMAIL:-alex@fake.org}
export DISK=${DISK:-250}
export MACHINE_FAMILY=${MACHINE_FAMILY:-n2}
export MACHINE_TYPE=${MACHINE_TYPE:-standard}
export MACHINE_CPU=${MACHINE_CPU:-32}
export MACHINE_DEFINITION=$MACHINE_FAMILY-$MACHINE_TYPE-$MACHINE_CPU
export NAMESPACE=${NAMESPACE:-galaxy}
export NAME=${NAME:-galaxy}
export CLUSTER_NAME=${CLUSTER_NAME:-ks-$MACHINE_DEFINITION-$(date +%d%m)$YEAR}
export KUBE=${KUBE:-$MACHINE_FAMILY}

GXY_TMP=/tmp/anvil-output.txt
VALUES=/tmp/anvil-values.yml

# ANSI color codes for the console.
reset="\033[0m"
bold="\033[1m"
ital="\033[3m" # does not work on OS X

# Function used to highlight text.
function hi() {
    echo -e "$bold$@$reset"
}

function help() {
    cat | less -R << EOF 
    
$(hi USAGE)
   $0 [cluster|disks|galaxy|cleanup]

$(hi SYNOPSIS)
    Provisions an Galaxy clusters on GCP using the Galaxy Kubeman Helm chart.

$(hi COMMANDS)
    $(hi cluster)  
        provision a GKE cluster on GCP
    $(hi disk)|$(hi disks)    
        provision two peristent disks for Postgres and NFS
    $(hi galaxy)    
        deploy Galaxy to the cluster using the Kubeman helm chart
    $(hi cleanup)  
        destroy the cluster and disks
    $(hi -h)|$(hi --help)|$(hi help)
        print this help message and exit

Press $(hi Q) (twice) to exit help.
EOF
}

if [[ $# = 0 ]] ; then
    help
    exit
fi

function cleanup() {
    echo "Cleaning up"
    gcloud container clusters delete -q $CLUSTER_NAME --zone $ZONE;
    gcloud compute disks delete -q "$CLUSTER_NAME-postgres-pd" --zone $ZONE;
    gcloud compute disks delete -q "$CLUSTER_NAME-nfs-pd" --zone $ZONE;
}

function cluster() {
    echo "Creating the cluster"
    gcloud container clusters create "$CLUSTER_NAME" --cluster-version="$GKE_VERSION" --disk-size=100 --num-nodes=1 --machine-type=$MACHINE_DEFINITION --zone "$ZONE"
    cp ~/.kube/config ~/.kube/configs/$KUBE
}

function disks() {
    echo "Provisioning persistent storage"
    gcloud compute disks create "$CLUSTER_NAME-postgres-pd" --size 10Gi --zone "$ZONE" 
    gcloud compute disks create "$CLUSTER_NAME-nfs-pd" --size "$DISK""Gi" --zone "$ZONE"
}

function galaxy() {
    echo "Deploying Galaxy with the Galaxy Kubeman helm chart"
helm install $NAME -n $NAMESPACE $CHART\
 --create-namespace\
 --wait\
 --timeout 2800s\
 --version $GKM_VERSION\
 --set galaxy.image.repository="$IMAGE"\
 --set galaxy.image.tag="$TAG"\
 --set nfs.storageClass.name="nfs-$CLUSTER_NAME"\
 --set cvmfs.repositories.cvmfs-gxy-data-$CLUSTER_NAME="data.galaxyproject.org"\
 --set cvmfs.cache.alienCache.storageClass="nfs-$CLUSTER_NAME"\
 --set galaxy.persistence.storageClass="nfs-$CLUSTER_NAME"\
 --set galaxy.cvmfs.galaxyPersistentVolumeClaims.data.storageClassName=cvmfs-gxy-data-$CLUSTER_NAME\
 --set galaxy.service.type=LoadBalancer\
 --set galaxy.service.port=8000\
 --set rbac.enabled=false\
 --set galaxy.configs."file_sources_conf\.yml"=""\
 --set galaxy.terra.launch.workspace="De novo transcriptome reconstruction with RNA-Seq"\
 --set galaxy.terra.launch.namespace="galaxy-anvil-edge"\
 --set cvmfs.cache.preload.enabled=false\
 --set galaxy.configs."galaxy\.yml".galaxy.master_api_key=$PASSWORD\
 --set galaxy.configs."galaxy\.yml".galaxy.single_user="$EMAIL"\
 --set galaxy.configs."galaxy\.yml".galaxy.admin_users="$EMAIL"\
 --set galaxy.configs."galaxy\.yml".galaxy.job_metrics_config_file=job_metrics_conf.yml\
 --set-file galaxy.configs."job_metrics_conf\.yml"=job_metrics_conf.yml \
 --set persistence.nfs.name="$CLUSTER_NAME-nfs-disk"\
 --set persistence.nfs.persistentVolume.extraSpec.gcePersistentDisk.pdName="$CLUSTER_NAME-nfs-pd"\
 --set persistence.nfs.size="$DISK""Gi"\
 --set persistence.postgres.name="$CLUSTER_NAME-postgres-disk"\
 --set persistence.postgres.persistentVolume.extraSpec.gcePersistentDisk.pdName="$CLUSTER_NAME-postgres-pd"\
 --set persistence.postgres.size="10Gi"\
 --set nfs.persistence.existingClaim="$CLUSTER_NAME-nfs-disk-pvc"\
 --set nfs.persistence.size="$DISK""Gi"\
 --set galaxy.postgresql.persistence.existingClaim="$CLUSTER_NAME-postgres-disk-pvc"\
 --set galaxy.persistence.size="200Gi"\
 --set galaxy.postgresql.galaxyDatabasePassword=$PASSWORD\
 --set galaxy.postgresql.master.nodeSelector."cloud\.google\.com\/gke-nodepool"="default-pool"\
 --set galaxy.nodeSelector."cloud\.google\.com\/gke-nodepool"="default-pool"\
 --set cvmfs.nodeSelector."cloud\.google\.com\/gke-nodepool"="default-pool"\
 --set nfs.nodeSelector."cloud\.google\.com\/gke-nodepool"="default-pool"\
 --set galaxy.postgresql.master.nodeSelector."cloud\.google\.com\/gke-nodepool"="default-pool"\
 --set galaxy.configs."job_conf\.yml".runners.k8s.k8s_node_selector="cloud.google.com/gke-nodepool: default-pool"\
 --set galaxy.webHandlers.startupDelay=10\
 --set galaxy.jobHandlers.startupDelay=5\
 --set galaxy.workflowHandlers.startupDelay=0\
 --set nfs.nodeSelector."cloud\.google\.com\/gke-nodepool"="default-pool" 

    echo "http://$(kubectl get svc -n $NAMESPACE $NAME-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}' | sed -e 's/"//g'):$(kubectl get svc -n $NAMESPACE $NAME-nginx -o jsonpath='{.spec.ports[0].port}')$(kubectl get ingress -n $NAMESPACE $NAME -o jsonpath='{.spec.rules[0].http.paths[0].path}')/"
}

function url() {
    echo "http://$(kubectl get svc -n $NAMESPACE $NAME-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}' | sed -e 's/"//g'):$(kubectl get svc -n $NAMESPACE $NAME-nginx -o jsonpath='{.spec.ports[0].port}')$(kubectl get ingress -n $NAMESPACE $NAME -o jsonpath='{.spec.rules[0].http.paths[0].path}')/"
}

function show() {
    cat << __EOF__
export NAMESPACE=$NAMESPACE
export NAME=$NAME
export GKE_VERSION=$GKE_VERSION
export ZONE=$ZONE
export CHART=$CHART
export GKM_VERSION=$GKM_VERSION
export CLUSTER_NAME=$CLUSTER_NAME
export IMAGE=$IMAGE
export TAG=$TAG
export PASSWORD=$PASSWORD
export EMAIL=$EMAIL
export DISK=$DISK
export MACHINE_FAMILY=$MACHINE_FAMILY
export MACHINE_TYPE=$MACHINE_TYPE
export MACHINE_CPU=$MACHINE_CPU 
export KUBE=$KUBE
__EOF__
}

function clear() {
    cat << __EOF__
unset NAMESPACE
unset NAME
unset CLUSTER_NAME
unset IMAGE
unset TAG
unset PASSWORD
unset EMAIL
unset DISK
unset ZONE
unset GKM_VERSION
unset CHART
unset GKE_VERSION
unset MACHINE_FAMILY
unset MACHINE_TYPE
unset MACHINE_CPU
unset KUBE
__EOF__
}


# Save command line arguments so we can shift through them twice; once to check
# that all commands are valid, and a second time to run the commands.
saved=$@

while [[ $# > 0 ]] ; do
    case $1 in
        cluster|disks|galaxy|cleanup|show|clear) 
            $1 
            ;;
        -h|--help|help)
            help
            exit
            ;;
        disk) 
            disks 
            ;;
        *)
            echo "$(hi ERROR): Invalid option $1"
            echo
            echo "Run $(hi $0 help) for usage instructions." 
            exit
            ;;
    esac
    shift
done

