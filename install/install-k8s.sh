#!/bin/bash -e
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

USER=stack
GROUP=stack
CIDR="192.168.0.0/16"

apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet=1.7.5-00 kubeadm=1.7.5-00 kubectl=1.7.5-00
#apt-get install -y kubelet kubeadm kubectl

kubeadm version
kubeadm init --kubernetes-version v1.7.5 --pod-network-cidr=${CIDR}
#kubeadm init --token ${token} --kubernetes-version v1.7.5 --pod-network-cidr=${CIDR}

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#chown $(id -u):$(id -g) $HOME/.kube/config
chown -R ${USER}:${GROUP} $HOME/.kube

sudo -u ${USER} kubectl apply -f http://docs.projectcalico.org/v2.4/getting-started/kubernetes/installation/hosted/kubeadm/1.6/calico.yaml
sudo -u ${USER} kubectl taint nodes --all node-role.kubernetes.io/master-
