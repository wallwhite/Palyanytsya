#!/bin/bash
echo "Stop vpn..."

CONTAINER_NAME=expressvpn
CONTAINER_ID=$(docker ps -aqf "name=$CONTAINER_NAME")

if [ -n "$CONTAINER_ID" ]; then
  docker rm $CONTAINER_ID
fi


