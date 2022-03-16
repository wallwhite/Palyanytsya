#!/bin/bash
sh scripts/stopvpn.sh

docker-compose down
docker-compose kill

bash scripts/cleanup.sh