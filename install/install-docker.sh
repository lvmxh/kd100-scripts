#!/bin/bash -e
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

USER=stack

apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -y
apt-get install -y docker-ce=17.03.2~ce-0~ubuntu-xenial
docker version

usermod -aG docker $USER
iptables -A FORWARD -i eth0 -o docker0 -j ACCEPT
cat <<EOF >/etc/docker/daemon.json
{
  "live-restore": true
}
EOF
service docker restart
