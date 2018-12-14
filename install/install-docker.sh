#!/bin/bash -e
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# USER=stack
# USER=ubuntu

apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -y
# kubernetes 1.9 only tested with 17.03.2
# apt-get install -y docker-ce=17.03.2~ce-0~ubuntu-xenial
#apt-get install -y docker-ce=17.09
apt-get install -y docker-ce
docker version

usermod -aG docker $USER

# Nice to have: make sure if dockerd is restarted it won't kill k8s
cat <<EOF >/etc/docker/daemon.json
{
  "live-restore": true
}
EOF

# Docker is configured to drop external traffic. Appending the forwarding rule allows
# access the docker0, which allows kubernetes nodePort to work.
# iptables -A FORWARD -i eth0 -o docker0 -j ACCEPT
service docker restart
