echo "initialization on Windows"
echo "install brew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [[ $(command -v brew) == "" ]]; then
   echo "Installing Hombrew"
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    brew update
fi

if [[ $(command -v node) == "" ]]; then
   echo "Installing Node"
   brew install node
fi

echo "Install yarn "
npm install --global yarn

echo "Install Typescript"
npm install -g typescript