#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

kubectl drain lab --delete-local-data --force --ignore-daemonsets
kubectl delete node lab
kubeadm reset
iptables -D FORWARD -i eth0 -o docker0 -j ACCEPT
rm -rf $HOME/.kube
