#!/bin/bash

git clone https://github.com/wallwhite/Palyanytsya.git

cd ./Palyanytsya

UNAME=$(uname)
echo $uname

# commented due to testing purposes

# if [ "$UNAME" == "Linux" ] ; then
#   bash ./scripts/init-linux.sh
# elif [ "$UNAME" == "Darwin" ] ; then
#   bash ./scripts/init-mac.sh
# else
#   bash ./scriptsinit-windows.sh
# fi

echo "initialization on Linux"

echo "Updating packages..."
sudo apt update

# TODO add universal check function

# init-linux.sh
echo "Installing Node"
sudo apt-get install -y nodejs


echo "Install yarn "
npm install --global yarn

echo "Install Typescript"
npm install -g typescript


bash start.sh
