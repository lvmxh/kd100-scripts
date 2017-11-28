#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

service docker stop
apt-get remove docker docker-engine docker.io docker-ce
