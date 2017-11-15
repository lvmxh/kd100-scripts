#!/bin/bash -e
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet=1.7.5-00 kubeadm=1.7.5-00 kubectl=1.7.5-00
#apt-get install -y kubelet kubeadm kubectl
kubeadm version


