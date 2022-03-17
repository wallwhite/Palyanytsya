#!/bin/bash

# Remove Dead and Exited containers.
docker rm $(docker ps -a | grep "Dead\|Exited" | awk '{print $1}'); true
docker container prune -f --filter "until=24h"

# It will fail to remove images currently in use.
docker rmi $(docker images -qf dangling=true); true
docker image prune -af --filter "until=24h"

# Clean up unused docker volumes
docker volume rm $(docker volume ls -qf dangling=true); true
docker volume prune -f

docker-compose rm -f
