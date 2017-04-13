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


echo "${GREEN}Create docker machine for consul server${NONE}"
docker-machine create -d virtualbox --virtualbox-memory "1000" consul-server


echo "${GREEN}Setup environment for consul server node${NONE}"
eval $(docker-machine env consul-server)

sleep 2

echo "${GREEN}Startup Docker Compose${NONE}"
docker-compose -f consul-server-compose.yml up
#docker stack deploy --compose-file consul-server-compose.yml consul