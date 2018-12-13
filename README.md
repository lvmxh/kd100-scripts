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
* sudo USER=$USER GROUP=$USER ./install/install-docker.sh
* sudo CALICOVER=master CALICONETVER=1.7 USER=$USER GROUP=$USER NIC=ens3 ./install/install-k8s.sh
* 
* To setup student environments we should use at tag or branch. I've
* setup a "latest", but tag creates a detached head, so may switch to
* a branch instead:
* git checkout tags/latest

### How do I test? ###

* kubectl create -f test
* port=$(kubectl get svc echoserver -o jsonpath='{.spec.ports[0].nodePort}')
* pubip=$(curl -s 169.254.169.254/2016-09-02/meta-data/public-ipv4)
* curl ${pubip}:${port}

### How do I enable kubernetes-dashboard? ###

* kubectl create -f ~/kd100-scripts/dashboard/kube-dashboard.yaml
* port=$(kubectl get svc kubernetes-dashboard -n kube-system -o jsonpath='{.spec.ports[0].nodePort}')
* pubip=$(curl -s 169.254.169.254/2016-09-02/meta-data/public-ipv4)
* echo ${pubip}:${port}
* Paste the output into your browser window

### Who do I talk to? ###

* Reza Roodsari


### How to install calico network  ###

* [master nightly] (https://docs.projectcalico.org/master/getting-started/kubernetes/)
* [latest version] (https://docs.projectcalico.org/latest/getting-started/kubernetes/)
* [v3.4 less 50 nodes] (https://docs.projectcalico.org/v3.4/getting-started/kubernetes/installation/calico#installing-with-the-kubernetes-api-datastore50-nodes-or-less)
* [calico git hub] (https://github.com/projectcalico/calico)
