echo "initialization on Linux"

echo "Updating packages..."
sudo apt update

# TODO add universal check function

if [[ $(command -v node) == "" ]]; then
   echo "Installing Node"
   sudo apt-get install -y nodejs
fi

if [[ $(command -v yarn) == "" ]]; then
   echo "Install yarn "
   npm install --global yarn
fi

if [[ $(command -v yarn) == "" ]]; then
   echo "Install Typescript"
   npm install -g typescript
fi
