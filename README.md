# README #

Because docker and k8s versions are changing constantly, we should decouple docker and k8s installation
steps from lab manuals. We can do this using scripts in this publicly available repository.

### What is this repository for? ###

* Quick summary
* Version
* [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)

### How do I get set up? ###

* git clone https://bitbucket.org/mirantis-training/kd100-scripts
* cd kd100-scripts
* sudo ./install/install-docker.sh
* sudo ./install/install-k8s.sh

### How do I test? ###

* kubectl create -f labs
* port=$(kubectl get svc echoserver -o jsonpath='{.spec.ports[0].nodePort}')
* pubip=$(curl -s 169.254.169.254/2016-09-02/meta-data/public-ipv4)
* curl ${pubip}:${port}

### Who do I talk to? ###

* Reza Roodsari
