git clone https://github.com/wallwhite/Palyanytsya.git

cd ./Palyanytsya

UNAME=$(uname)

if [ "$UNAME" == "Linux" ] ; then
  bash ./scripts/init-linux.sh
elif [ "$UNAME" == "Darwin" ] ; then
  bash ./scripts/init-mac.sh
else  
  bash ./scriptsinit-windows.sh
fi

bash start.sh
