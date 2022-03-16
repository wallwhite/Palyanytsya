#!/bin/bash 

bash scripts/stop.sh

git pull

bash scripts/start.sh -l start
