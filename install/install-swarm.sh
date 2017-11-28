#!/bin/bash -e
#Inspired by https://github.com/alexei-led/swarm-mac

# vars
[ -z "$NUM_WORKERS" ] && NUM_WORKERS=3

# swarm mode requires us to clean up setting for k8s
cat <<EOF >/etc/docker/daemon.json
{
}
EOF
service docker restart

# init swarm (need for service command); if not created
echo "Creating Docker Swarm master ..."
docker swarm init

# get join token and Swarm master IP
SWARM_TOKEN=$(docker swarm join-token -q worker)
SWARM_MASTER=$(docker info --format "{{.Swarm.NodeAddr}}")

# start Docker registry mirror
echo "Starting local Docker Registry mirror ..."
docker run -d --restart=always -p 4000:5000 --name v2_mirror \
  -v "$HOME"/.registrydata:/var/lib/registry \
  -e REGISTRY_PROXY_REMOTEURL=https://registry-1.docker.io \
  registry:2.5

# run NUM_WORKERS workers with local registry proxy
for i in $(seq "${NUM_WORKERS}"); do
  echo "Starting Docker swarm worker #${i} ..."
  docker run -d --privileged --name "worker-${i}" --hostname="worker-${i}" \
    -p ${i}2375:2375 \
    -p ${i}5000:5000 \
    -p ${i}5001:5001 \
    -p ${i}5601:5601 \
    docker:17.03.0-ce-dind \
      --storage-driver=overlay2 \
      --registry-mirror "http://${SWARM_MASTER}:4000"
done

# Add worker container to the cluster with SWARM_TOKEN
for i in $(seq "${NUM_WORKERS}"); do
  echo "swarm worker #${i} joining the cluster ..."
  docker --host="localhost:${i}2375" swarm join --token "${SWARM_TOKEN}" "${SWARM_MASTER}:2377"
done

# show swarm cluster
printf "\nLocal Swarm Cluster\n===================\n"
echo "$(tput setaf 3) docker node ls $(tput sgr 0)"
docker node ls

# echo swarm visualizer
printf "\nLocal Swarm Visualizer\n===================\n"
docker run -it -d --name swarm_visualizer \
  -p 8080:8080 -e HOST=localhost \
  -v /var/run/docker.sock:/var/run/docker.sock \
  dockersamples/visualizer

