#!/bin/bash 

# Colors
RED="\033[0;31m"
BLUE="\033[0;36m"
GREEN="\033[0;32m"
ENDCOLOR="\033[0m"

# Constants
API_HOST="https://api.palyanytsya.online"
REGISTER_WORKER_URL="${API_HOST}/workers/register"
UPDATE_WORKER_URL="${API_HOST}/workers/update"
CONTAINERS_COUNT=0
EXPRESSVPN_KEY=""
declare -a REGIONS=("frpa1" "frst" "frpa2" "frma" "uklo" "ukdo" "ukel" "ukel" "nlth" "nlam2" "usny" "nlro" "usny" "uswd" "usla" "usnj3" "se" "se2" "ch2" "itco" "denu" "defr1" "defr2" "defr3" "kg" "uz" "cato" "mx" "ro" "esma" "esba" "tr" "ie" "is" "no" "dk" "gr" "pt" "at" "am" "pl" "lt" "ee" "cz" "me" "ba" "hu" "bg" "by" "cy" "al" "si" "sk" "il" "eg")

# Functions
function jsonval {
    temp=`echo $json | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $prop  | sed 's/.*://'`
    echo ${temp##*|}
}

function printHelp {
  echo "\n***[${GREEN}HELP${ENDCOLOR}]***\n\n${BLUE}Palyanytsya help${ENDCOLOR}"
  echo " "
  echo "Options:"
  echo "  -h, --help                Show this help"
  echo "  -q ARG                    Set containers quantity number. ARG - is number of containers"
  echo "  -c ARG                    Set ExpressVPN code. ARG - is code from your expressvpn profile"
  echo " "

  exit 0
}

# Clean composer
FILE=./docker-compose.yml
if test -f "$FILE"; then
  sh stop.sh
  rm -rf ./docker-compose.yml
  echo "\n[${GREEN} INFO ${ENDCOLOR}]: Deprecated docker-compose removed"
fi

# Clean deprecated threads
rm -rf ./thread*
echo "\n[${GREEN} INFO ${ENDCOLOR}]: Deprecated treads removed"

# Clean deprecated env
FILE_ENV=./.env
if test -f "$FILE_ENV"; then
  rm -rf ./.env
  echo "\n[${GREEN} INFO ${ENDCOLOR}]: Deprecated .env removed"
fi

cp ./.env.example ./.env
echo "\n[${GREEN} INFO ${ENDCOLOR}]: New .env created"

# Get params
while getopts q:c:h:help: flag
do
    case "${flag}" in
        q) CONTAINERS_COUNT=${OPTARG};;
        c) EXPRESSVPN_KEY=${OPTARG};;
        h|help) printHelp
    esac
done

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

echo "[${GREEN} INFO ${ENDCOLOR}]: You chose: ${BLUE} ${CONTAINERS_COUNT} Containers ${ENDCOLOR}"

# Test is exists worker id
FILE_VPN_KEY=./VPN_KEY
if test -f "$FILE_VPN_KEY"; then
  EXPRESSVPN_KEY=$(<VPN_KEY)
  echo "[${GREEN} INFO ${ENDCOLOR}]: VPN key exists and read successfully."
else
  read -p "Enter ExpressVPN key: " EXPRESSVPN_KEY
  touch VPN_KEY
  printf "$EXPRESSVPN_KEY" >> ./VPN_KEY
  echo "[${GREEN} INFO ${ENDCOLOR}]: VPN key saved successfully."
fi

# Write environment variables
FILE_DIST=./.env
if test -f "$FILE_DIST"; then
  printf '\nCODE="'$EXPRESSVPN_KEY'"\n' >> ./.env
  printf 'SERVER="'$VPN_REGION'"\n' >> ./.env
  echo "[${GREEN} INFO ${ENDCOLOR}]: ENV data saved successfully."
else
  echo "[${RED} ERROR ${ENDCOLOR}]: ENV file does not exist."
  exit 1
fi
 
# Select random vpn region
VPN_REGION=${REGIONS[$RANDOM % ${#REGIONS[@]} ]}

# Test is exists worker id
FILE_WORKER=./WORKER_ID
if test -f "$FILE_WORKER"; then
  WORKER=$(<WORKER_ID)
  json="$(curl -X POST -H "Content-Type: application/json" -d '{"id": "'$WORKER'", "threadsCount":"10", "location": "'$VPN_REGION'"}' $UPDATE_WORKER_URL)"
  prop='statusCode'
  statusCode=`jsonval`

  if [[ $statusCode -eq "404" ]]
  then
    echo "[${RED} ERROR ${ENDCOLOR}]: Wrong worker ID."
    rm -rf $FILE_WORKER
    bash start.sh -q $CONTAINERS_COUNT
    exit
  fi
else
  WORKER="$(curl -X POST -H "Content-Type: application/json" -d '{"location": "'$VPN_REGION'", "threadsCount":"10"}' $REGISTER_WORKER_URL)"
  touch WORKER_ID
  printf "$WORKER" >> ./WORKER_ID
fi

# Go to the script directory
cd ./worker

# Build the bundle
BUILD_DIR=./build
if test -d "$BUILD_DIR"; then
  echo "\n[${GREEN} INFO ${ENDCOLOR}]: Palyanytsya build exists."
  echo ''
else
  yarn build
  echo "\n[${GREEN} INFO ${ENDCOLOR}]: Palyanytsya bundle built."
fi

cd ../

# Start 
cp -R ./docker-compose.template ./docker-compose.yml

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

# Start the containers
docker-compose up -d

# Finish log
echo "\n[${GREEN} INFO ${ENDCOLOR}]: Worker id is: ${WORKER}, count of containers: ${CONTAINERS_COUNT} in region: ${VPN_REGION}. \n[${GREEN} INFO ${ENDCOLOR}]: JOB RUN SUCCESSFULLY"
