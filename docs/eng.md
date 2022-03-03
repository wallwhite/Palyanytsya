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


## Easy initialization

For initialization use the following command:
```
bash init.sh
```

command arguments:

- `-c` - your code from express vpn
- `-a` - alias from table below

You also can initialize by yourself via .env.example -> .env and many changes.

------------------------------------------------

command example:

```
bash init.sh -c ffu34hsdf8ee4nfsdn34nsfd -a frma
```

where `ffu34hsdf8ee4nfsdn34nsfd` - is your code and `frma` is France server alias from table.

## Solution configuration and starting

This configurarion should be done after initialization.

Command line arguments

- `-q` - containers quantity 
- `-s` - server
- `-r` - requests count (do not use very large numbers, i think optimal value is arround 10-100k)
- `-c` - connections count

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
bash start.sh -q 1 -s http://127.0.0.1:80 -r 10 -c 120
```
## Environment

You should configure your .env file from .env.example

required properties:

- `CODE` - activation code from expressvpn
- `SERVER` - server alias (use aliases from table below)

## Contributing

If you wanna make this script better, please create pull-requests with your proposals.

## VPN aliases

There are vpn servers that you can use.
You should put value from *ALIAS* column as value od *SERVER* in your `.env` 


