# Palyanytsya

Well, are you ready for a new arson?

## What is it?

This is utility for massive servers benchmarking using vpn and dynamic count of containers.

## Requirements

- Any machine with docker engine
- Docker
- Expressvpn account
- Your hands 
- Imaginativeness

--------------

You also could deploy it on S3, Azure, Digital Ocean or other cloud.

## Using 

- Clone repo
```
git clone https://github.com/wallwhite/Palyanytsya.git
```
- Go inside dir
```
cd ./Palyanytsya
```

- Install node.js (next command for ubuntu)

```
apt install nodejs
```



## Easy starting

For starting use the following command:
```
bash start.sh
```

Command line arguments:

- `-q` - Set containers quantity number. 
- `-c` - Set ExpressVPN code.
- `-help` , `-h` - help

You also can set this data step by step running the following command `bash start.sh` without arguments.

VPN region will be selected randomly by script and will be changed later on another.

Also, target for benchmarking will be requested from our targets base.

You only have to run this script once on the server and you will make a big contribution to our cyber defense.

Target base will be released later with statuses.

------------------------------------------------

command example:

```
bash start.sh -c ffu34hsdf8ee4nfsdn34nsfd -q 10
```

where `ffu34hsdf8ee4nfsdn34nsfd` - is your code  ExpressVPN and `10` - conteiners count.

### Commands

start:
```
bash start.sh
```

stop:
```
bash stop.sh
```

example: 
```
bash start.sh -q 1 -q fsdf342jnnsjnjr3n
```
## Contributing

If you wanna make this script better, please create pull-requests with your proposals.
