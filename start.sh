#!/bin/bash 
# Clean
FILE=./docker-compose.yml
if test -f "$FILE"; then
  sh stop.sh
  rm -rf ./docker-compose.yml
fi

# Start 
cp -R ./docker-compose-dist.yml ./docker-compose.yml

while getopts q:s:r:c: flag
do
    case "${flag}" in
        q) containers_count=${OPTARG};;
        s) server=${OPTARG};;
        r) requests_count=${OPTARG};;
        c) connections_count=${OPTARG};;
    esac
done

for ((INDEX = 0 ; INDEX <= $((containers_count-1)) ; INDEX++)); do
	printf '  thread'$INDEX':\n' >> docker-compose.yml
  printf '    image: golang:rc-alpine3.15\n' >> docker-compose.yml
  printf '    container_name: thread'$INDEX'\n' >> docker-compose.yml
  printf '    working_dir: /app\n' >> docker-compose.yml
  printf '    network_mode: service:expressvpn\n' >> docker-compose.yml
  printf '    command: sh start.sh -s '$server' -r '$requests_count' -c '$connections_count' \n' >> docker-compose.yml
  printf '    volumes:\n' >> docker-compose.yml
  printf '      - ./thread'$INDEX':/app\n' >> docker-compose.yml
  printf '    restart: always\n' >> docker-compose.yml

  cp -R ./thread-dist ./thread${INDEX}
done

docker-compose up -d