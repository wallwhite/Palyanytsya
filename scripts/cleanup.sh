#!/bin/bash

# Remove Dead and Exited containers.
docker rm $(docker ps -a | grep "Dead\|Exited" | awk '{print $1}'); true

# It will fail to remove images currently in use.
docker rmi $(docker images -qf dangling=true); true

# Clean up unused docker volumes
docker volume rm $(docker volume ls -qf dangling=true); true

docker-compose rm -f