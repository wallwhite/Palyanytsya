echo "initialization on Windows"

echo "BE SURE, YOU'RE RUNNING THE SCRIPT UNDER ADMIN ROLE!"

echo "Installing chocolately"
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

echo "Updating packages..."
choco update -a

choco install nvs

nvs add lts
nvs use lts

node -v

npm install --global yarn

echo "Install Typescript"
npm install -g typescript 
