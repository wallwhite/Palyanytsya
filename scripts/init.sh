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

# Install packages and package manager
echo "Updating packages..."

UNAME="$(uname)"

case "${UNAME}" in
  'Linux')
    sudo apt update
  ;;
  'Darwin')
    if ! command -v brew &> /dev/null
    then
      bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
  ;;
  *)
    MESSAGE_TYPE="ERROR"
    MESSAGE="Your OS: [$(uname)] does not support NodeJS automaticaly. Try to visit https://nodejs.org for more information."
    printMessage
  ;;
esac

if ! command -v node &> /dev/null
then
  MESSAGE_TYPE="WARNING"
  MESSAGE="NodeJS does not exist. We try to install automaticaly if your OS is MacOS or Linux. If your OS is windows please install NodeJS"
  printMessage
  
  case "${UNAME}" in
    'Linux')
      curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
      sudo apt-get install -y nodejs
    ;;
    'Darwin')
      brew install node@14
    ;;
    *)
      MESSAGE_TYPE="ERROR"
      MESSAGE="Your OS: [$(uname)] does not support NodeJS automaticaly. Try to visit https://nodejs.org for more information."
      printMessage
    ;;
  esac
fi

if ! command -v yarn &> /dev/null
then
  MESSAGE_TYPE="WARNING"
  MESSAGE="Yarn package manager does not exist. We try to install automaticaly."
  printMessage

  npm install --global yarn
fi

if ! command -v tsc &> /dev/null
then
  MESSAGE_TYPE="WARNING"
  MESSAGE="Typescript does not exist. We try to install automaticaly."
  printMessage

  npm install -g typescript
fi

MESSAGE_TYPE="INFO"
MESSAGE="Initialization completed."
printMessage

npm install -g node-cron