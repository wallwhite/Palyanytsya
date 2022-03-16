#!/bin/bash 

BLUE=$'\e[0;34m'
YELLOW=$'\e[0;33m'
GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
NC=$'\e[0m'

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

echo "Cron jobs execution"

cd scripts/cron

FILE_ENV=./.env
if test -f "$FILE_ENV"; then
  rm -rf ./.env

  MESSAGE_TYPE="INFO - CRON"
  MESSAGE="Deprecated .env removed"
  printMessage
fi

cp ./.env.example ./.env
MESSAGE_TYPE="INFO - CRON"
MESSAGE="New .env created"
printMessage

npm install

VAL="$(npm run start)" 

COMMAND=`echo $VAL | awk "NR==1{print}" | awk 'NF>1{print $NF;exit}'`

case "${COMMAND}" in
  'UPDATE')
  MESSAGE_TYPE="INFO"
  MESSAGE="Update command returned from Cron. Start updating."
  printMessage

  cd ../..

  bash scripts/update.sh
  ;;
  'RESTART')
  MESSAGE_TYPE="INFO"
  MESSAGE="Restarting command returned from Cron. Start reloading."
  printMessage
 
  cd ../..

  bash scripts/restart.sh
  ;;
  *)
  MESSAGE_TYPE="ERROR"
  MESSAGE="WRONG COMMAND RETURNED FROM CRON JOB"
  printMessage
  exit 1
  ;; 
esac
