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

echo "${GREEN} ---Create consul-manager-1 ${NONE}"
docker-machine create -d virtualbox --engine-label access=consul-cluster consul-manager-1

manager_ip=$(docker-machine ip consul-manager-1)

echo "${GREEN} ---Swarm Init ${NONE}"
docker-machine ssh consul-manager-1 docker swarm init --listen-addr ${manager_ip} --advertise-addr ${manager_ip}

printf "\n---Get Tokens\n"
manager_token=$(docker-machine ssh consul-manager-1 docker swarm join-token -q manager)
worker_token=$(docker-machine ssh consul-manager-1 docker swarm join-token -q worker)
echo ${YELLOW} ${manager_token} ${NONE}
echo ${YELLOW} ${worker_token} ${NONE}


# for n in {2..3} ; do
# 	printf "\n---Create consul-manager-${n}\n"
# 	docker-machine create -d virtualbox \
#   --engine-label access=consul-cluster consul-manager-${n}
# 	ip=$(docker-machine ip consul-manager-${n})
# 	echo "--- Swarm Manager Join"
# 	docker-machine ssh consul-manager-${n} docker swarm join --listen-addr ${ip} --advertise-addr ${ip} --token ${manager_token} ${manager_ip}:2377
# done

printf "\n---Create consul-worker-seed\n"
docker-machine create -d virtualbox --engine-label access=consul-seed consul-worker-seed
ip=$(docker-machine ip consul-worker-seed)
echo "${GREEN}--- Swarm Worker Join ${NONE}"
docker-machine ssh consul-worker-seed docker swarm join --listen-addr ${ip} --advertise-addr ${ip} --token ${worker_token} ${manager_ip}:2377

for n in {1..3} ; do
	printf "\n---Create consul-worker-${n}\n"
	docker-machine create -d virtualbox --engine-label access=consul-cluster consul-worker-${n}
	ip=$(docker-machine ip consul-worker-${n})
	echo "${GREEN} ---Swarm Worker Join ${NONE}"
	docker-machine ssh consul-worker-${n} docker swarm join --listen-addr ${ip} --advertise-addr ${ip} --token ${worker_token} ${manager_ip}:2377
done

printf "\n---Launching Visualizer\n"
docker-machine ssh consul-manager-1 docker run -it -d -p 8080:8080 -e HOST=${manager_ip} -e PORT=8080 -v /var/run/docker.sock:/var/run/docker.sock manomarks/visualizer

printf "\n\n------------------------------------\n"
echo "${GREEN} To connect to your cluster... ${NONE}"
echo "${GREEN} eval $(docker-machine env consul-manager-1) ${NONE}"
echo "${GREEN} To visualize your cluster... ${NONE}"
echo "${GREEN} Open a browser to http://${manager_ip}:8080/ ${NONE}"