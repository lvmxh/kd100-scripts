#!/bin/bash
#Inspired by https://github.com/alexei-led/swarm-mac

# vars
[ -z "$NUM_WORKERS" ] && NUM_WORKERS=3

# remove nodes
# run NUM_WORKERS workers with SWARM_TOKEN
printf "Removing worker nodes ...\n"
for i in $(seq "${NUM_WORKERS}"); do
  docker --host "localhost:${i}2375" swarm leave 
  docker rm --force "worker-${i}" 
done

# remove swarm cluster master
printf "Removing master ...\n"
docker swarm leave --force 

# remove docker mirror
printf "Removing Docker registry mirror ...\n"
docker rm --force v2_mirror 

# remove swarm visuzalizer
printf "Removing Swarm Visualizer ...\n"
docker rm --force swarm_visualizer 

echo "Running system prune"
docker system prune --force

rm -rf $HOME/.registrydata
