#!/bin/bash 

bash scripts/welcome.sh

# Constants
API_HOST="https://api.palyanytsya.online"
REGISTER_WORKER_URL="${API_HOST}/workers/register"
UPDATE_WORKER_URL="${API_HOST}/workers/update"
CONTAINERS_COUNT=0
CONTAINERS_COUNT_CACHED=0
EXPRESSVPN_KEY=""
declare -a REGIONS=("frpa1" "frst" "frpa2" "frma" "uklo" "ukdo" "ukel" "ukel" "nlth" "nlam2" "usny" "nlro" "usny" "uswd" "usla" "usnj3" "se" "se2" "ch2" "itco" "denu" "defr1" "defr2" "defr3" "kg" "uz" "cato" "mx" "ro" "esma" "esba" "tr" "ie" "is" "no" "dk" "gr" "pt" "at" "am" "pl" "lt" "ee" "cz" "me" "ba" "hu" "bg" "by" "cy" "al" "si" "sk" "il" "eg")
FILE_CONTAINERS_COUNT=./CONTAINERS_COUNT

# Colors
BLUE=$'\e[0;34m'
YELLOW=$'\e[0;33m'
GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
NC=$'\e[0m'

# System variables for printing messages
MESSAGE_TYPE=""; # INFO , WARNING, ERROR, SUCCESS
MESSAGE=""; # Any string

# Functions
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

function jsonval {
    temp=`echo $json | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $prop  | sed 's/.*://'`
    echo ${temp##*|}
}

function printHelp {
  echo "***[${GREEN}HELP${NC}]***"
  echo "${BLUE}Palyanytsya help${NC}"
  echo "${YELLOW}Options:${NC}"
  echo "  -help                Show this help"
  echo "  -q ARG                    Set containers quantity number. ARG - is number of containers"
  echo "  -c ARG                    Set ExpressVPN code. ARG - is code from your expressvpn profile"
  echo " "

  exit 0
}

########################################################################

# Get params

while getopts q:c:l:h:help: flag
do
    case "${flag}" in
        q) CONTAINERS_COUNT=${OPTARG};;
        c) EXPRESSVPN_KEY=${OPTARG};;
        l) if test -f "$FILE_CONTAINERS_COUNT"; then
            CONTAINERS_COUNT_CACHED=$(<CONTAINERS_COUNT)
           fi;;
        help) printHelp;;
        *) printHelp;;
    esac
done


########################################################################

# Clean composer

FILE=./docker-compose.yml
if test -f "$FILE"; then
  bash scripts/stop.sh
  rm -rf ./docker-compose.yml

  MESSAGE_TYPE="INFO"
  MESSAGE="Deprecated docker-compose removed"
  printMessage
fi

########################################################################

# Clean deprecated threads

rm -rf ./thread*

MESSAGE_TYPE="INFO"
MESSAGE="Deprecated treads removed"
printMessage

########################################################################

# Clean deprecated env

FILE_ENV=./.env
if test -f "$FILE_ENV"; then
  rm -rf ./.env

  MESSAGE_TYPE="INFO"
  MESSAGE="Deprecated .env removed"
  printMessage
fi

cp ./.env.example ./.env
MESSAGE_TYPE="INFO"
MESSAGE="New .env created"
printMessage

########################################################################

# Containers count seletion

MESSAGE_TYPE="INFO"
MESSAGE="Please select suitable containers count"
printMessage


if [[ !($CONTAINERS_COUNT_CACHED -eq 0) ]]
then
  CONTAINERS_COUNT="$CONTAINERS_COUNT_CACHED"
fi

if [[ $CONTAINERS_COUNT -eq 0 ]]
then
  PS3="Please select the option that corresponds to the desired number of containers:"
  options=("5 Containers" "10 Containers" "15 Containers" "20 Containrs" "Quit")
  select opt in "${options[@]}"
  do
      case $opt in
          "5 Containers")
              CONTAINERS_COUNT=5
              break
              ;;
          "10 Containers")
              CONTAINERS_COUNT=10
              break
              ;;
          "15 Containers")
              CONTAINERS_COUNT=15
              break
              ;;
          "20 Containrs")
              CONTAINERS_COUNT=20
              break
              ;;
          "Quit")
              echo "EXIT"
              exit 1
              break
              ;;
          *) echo "invalid option $REPLY";;
      esac
  done
fi

rm -rf ./CONTAINERS_COUNT
touch $FILE_CONTAINERS_COUNT
printf "$CONTAINERS_COUNT" >> $FILE_CONTAINERS_COUNT

MESSAGE_TYPE="SUCCESS"
MESSAGE="You chose: ${BLUE} ${CONTAINERS_COUNT} Containers ${NC}"
printMessage

########################################################################

# Test is exists worker id

FILE_VPN_KEY=./VPN_KEY
if test -f "$FILE_VPN_KEY"; then
  EXPRESSVPN_KEY=$(<VPN_KEY)

  MESSAGE_TYPE="INFO"
  MESSAGE="VPN key exists and read successfully."
  printMessage
else
  read -p "Enter ExpressVPN key: " EXPRESSVPN_KEY
  touch VPN_KEY
  printf "$EXPRESSVPN_KEY" >> ./VPN_KEY
  
  MESSAGE_TYPE="INFO"
  MESSAGE="VPN key saved successfully."
  printMessage
fi

########################################################################
 
# Select random vpn region

VPN_REGION=${REGIONS[$RANDOM % ${#REGIONS[@]} ]}

########################################################################

# Write environment variables

FILE_DIST=./.env
if test -f "$FILE_DIST"; then
  printf '\nCODE="'$EXPRESSVPN_KEY'"\n' >> ./.env
  printf 'SERVER="'$VPN_REGION'"\n' >> ./.env
  
  MESSAGE_TYPE="INFO"
  MESSAGE="ENV data saved successfully."
  printMessage
else
  MESSAGE_TYPE="ERROR"
  MESSAGE="ENV file does not exist."
  printMessage
  exit 1
fi

########################################################################

# Test is exists worker id

FILE_WORKER=./WORKER_ID
if test -f "$FILE_WORKER"; then
  WORKER=$(<WORKER_ID)
  json="$(curl -X POST -H "Content-Type: application/json" -d '{"id": "'$WORKER'", "threadsCount":"'$CONTAINERS_COUNT'", "location": "'$VPN_REGION'"}' $UPDATE_WORKER_URL)"
  prop='statusCode'
  statusCode=`jsonval`

  if [[ $statusCode -eq "404" ]]
  then
    MESSAGE_TYPE="ERROR"
    MESSAGE="Wrong worker ID."
    printMessage

    echo "${BLUE} RESTARTING... ${NC}"

    rm -rf $FILE_WORKER
    bash scripts/start.sh -q $CONTAINERS_COUNT
    exit
  fi
else
  WORKER="$(curl -X POST -H "Content-Type: application/json" -d '{"location": "'$VPN_REGION'", "threadsCount":"'$CONTAINERS_COUNT'"}' $REGISTER_WORKER_URL)"
  touch WORKER_ID
  printf "$WORKER" >> ./WORKER_ID
fi

########################################################################

# Go to the script directory
cd ./worker

MESSAGE_TYPE="INFO"
MESSAGE="Install dependencies."
printMessage

yarn install 

########################################################################

# Build the bundle

BUILD_DIR=./build
if test -d "$BUILD_DIR"; then
  MESSAGE_TYPE="INFO"
  MESSAGE="Remove old build."
  printMessage
  rm -rf ./build 
fi

MESSAGE_TYPE="INFO"
MESSAGE="Palyanytsya build fresh bundle."
printMessage

yarn build


cd ../

########################################################################

# Start 

MESSAGE_TYPE="INFO"
MESSAGE="Starting containers. Please wait..."
printMessage

cp -R ./docker-compose.template ./docker-compose.yml

printf '      - ACTIVATION_CODE='$EXPRESSVPN_KEY'\n' >> docker-compose.yml
printf '      - SERVER='$VPN_REGION'\n' >> docker-compose.yml

for ((INDEX = 0 ; INDEX <= $((CONTAINERS_COUNT-1)) ; INDEX++)); do
	printf '  thread'$INDEX':\n' >> docker-compose.yml
  printf '    image: node:16\n' >> docker-compose.yml
  printf '    container_name: thread'$INDEX'\n' >> docker-compose.yml
  printf '    working_dir: /app\n' >> docker-compose.yml
  printf '    network_mode: service:expressvpn\n' >> docker-compose.yml
  printf '    environment:\n' >> docker-compose.yml
  printf '      - API_HOST='$API_HOST'\n' >> docker-compose.yml
  printf '    command: yarn start\n' >> docker-compose.yml
  printf '    volumes:\n' >> docker-compose.yml
  printf '      - ./thread'$INDEX':/app\n' >> docker-compose.yml
  printf '    restart: always\n' >> docker-compose.yml

  cp -R ./worker ./thread${INDEX}
done

########################################################################

# Start the containers

docker-compose up -d

########################################################################

# Finish log

MESSAGE_TYPE="INFO"
MESSAGE="Worker id is: ${WORKER}, count of containers: ${CONTAINERS_COUNT} in region: ${VPN_REGION}."
printMessage

MESSAGE_TYPE="SUCCESS"
MESSAGE="JOB RUN SUCCESSFULLY"
printMessage

MESSAGE_TYPE="INFO"
MESSAGE="Start cron jobs"
printMessage

bash scripts/cron.sh