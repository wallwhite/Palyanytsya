#!/bin/bash 

echo "Updating packages..."
sudo apt update

echo "Install NodeJS"
curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -

echo "Install npm"
sudo apt-get install -y nodejs

echo "Install yarn "
npm install --global yarn

echo "Install Typescript"
npm install -g typescript