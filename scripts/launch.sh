#!/bin/bash

BLUE=$'\e[0;34m'
YELLOW=$'\e[0;33m'
GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
NC=$'\e[0m'


EXPRESSVPN_KEY=""
MESSAGE_TYPE=""; # INFO , WARNING, ERROR, SUCCESS
MESSAGE=""; # Any string


function printMessage {
  COLORMODE=$NC

  case "${MESSAGE_TYPE}" in
    'INFO')
    COLORMODE="$BLUE"
    ;;
    'WARNING')
    COLORMODE="$YELLOW"
    ;;
    'ERROR')
    COLORMODE="$RED"
    ;;
    'SUCCESS')
    COLORMODE="$GREEN"
    ;;
  esac

  
  echo "[${COLORMODE}${MESSAGE_TYPE}${NC}]: ${MESSAGE}"
}

if ! command -v git &> /dev/null
then
  MESSAGE_TYPE="ERROR"
  MESSAGE="You must install GIT before. Please visit https://git-scm.com for more information. "
  printMessage
  exit 1
fi

FILE_START=./scripts/start.sh
if test -f "$FILE_START"; then
  MESSAGE_TYPE="INFO"
  MESSAGE="Repository allready exists. Try to update."
  printMessage
  git pull
else
  MESSAGE_TYPE="INFO"
  MESSAGE="Repository does not exist. Try to clone."
  printMessage
  git clone https://github.com/wallwhite/Palyanytsya.git .
fi

while getopts q:c: flag
do
    case "${flag}" in
        q) CONTAINERS_COUNT=${OPTARG};;
        c) EXPRESSVPN_KEY=${OPTARG};;
        *)
        echo "Wrong parameters..." 
        ;;
    esac
done

MESSAGE_TYPE="INFO"
MESSAGE="Start initialization."
printMessage

bash scripts/init.sh

MESSAGE_TYPE="INFO"
MESSAGE="Start Palyanytsya."
printMessage

chmod +x scripts/start.sh

setsid scripts/start.sh -c $EXPRESSVPN_KEY -q $CONTAINERS_COUNT