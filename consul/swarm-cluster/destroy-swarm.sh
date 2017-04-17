#!/usr/bin/env bash
docker-machine rm -f consul-worker-seed
docker-machine rm -f consul-manager-{1..3} consul-worker-{1..3}