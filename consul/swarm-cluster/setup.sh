#!/bin/sh

NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
PURPLE='\033[01;35m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'


echo "${GREEN} Create swarm cluster for consul server ${NONE}"
./create-swarm.sh

echo "${GREEN} Connecting to swarm cluster... ${NONE}"
eval $(docker-machine env consul-manager-1)

echo "${GREEN} Startup docker cluster ${NONE}"
docker stack deploy --compose-file consul-cluster-compose.yml consul-cluster