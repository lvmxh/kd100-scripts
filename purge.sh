#!/bin/bash -e
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

kubectl drain lab --delete-local-data --force --ignore-daemonsets
kubectl delete node lab
kubeadm reset

apt-get remove docker docker-engine docker.io docker-ce
