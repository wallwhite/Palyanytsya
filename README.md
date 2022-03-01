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

This configurarion shoul be done after initialization.

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


```
ALIAS COUNTRY                     LOCATION                       RECOMMENDED
----- ---------------             ------------------------------ -----------
smart Smart Location              Czech Republic
frpa1 France (FR)                 France - Paris - 1             Y
frst                              France - Strasbourg            Y
frpa2                             France - Paris - 2
frma                              France - Marseille
fral                              France - Alsace
inmu1 India (IN)                  India - Mumbai - 1
in                                India (via UK)
inch                              India - Chennai
ukdo  United Kingdom (GB)         UK - Docklands                 Y
ukel                              UK - East London               Y
uklo                              UK - London
ukwe                              UK - Wembley
sgju  Singapore (SG)              Singapore - Jurong
sgcb                              Singapore - CBD
sgmb                              Singapore - Marina Bay
nlth  Netherlands (NL)            Netherlands - The Hague        Y
nlam                              Netherlands - Amsterdam        Y
nlam2                             Netherlands - Amsterdam - 2    Y
nlro                              Netherlands - Rotterdam
hk2   Hong Kong (HK)              Hong Kong - 2
hk1                               Hong Kong - 1
usny  United States (US)          USA - New York                 Y
uswd                              USA - Washington DC            Y
usla                              USA - Los Angeles              Y
usnj3                             USA - New Jersey - 3           Y
ussf                              USA - San Francisco
usch                              USA - Chicago
usda                              USA - Dallas
usmi                              USA - Miami
usla3                             USA - Los Angeles - 3
usnj1                             USA - New Jersey - 1
usla2                             USA - Los Angeles - 2
usse                              USA - Seattle
usmi2                             USA - Miami - 2
usde                              USA - Denver
ussl1                             USA - Salt Lake City
usta1                             USA - Tampa - 1
usph                              USA - Phoenix
usla1                             USA - Los Angeles - 1
usny2                             USA - New York - 2
usnj2                             USA - New Jersey - 2
usda2                             USA - Dallas - 2
usat                              USA - Atlanta
usla5                             USA - Los Angeles - 5
ussm                              USA - Santa Monica
jpto  Japan (JP)                  Japan - Tokyo
jpyo                              Japan - Yokohama
jpto2                             Japan - Tokyo - 2
aume  Australia (AU)              Australia - Melbourne
ausy                              Australia - Sydney
aupe                              Australia - Perth
aubr                              Australia - Brisbane
ausy2                             Australia - Sydney - 2
se    Sweden (SE)                 Sweden                         Y
se2                               Sweden - 2
ch2   Switzerland (CH)            Switzerland - 2                Y
ch                                Switzerland
itco  Italy (IT)                  Italy - Cosenza                Y
itmi                              Italy - Milan
denu  Germany (DE)                Germany - Nuremberg            Y
defr1                             Germany - Frankfurt - 1
defr2                             Germany - Frankfurt - 2
defr3                             Germany - Frankfurt - 3
kr2   South Korea (KR)            South Korea - 2
ph    Philippines (PH)            Philippines
my    Malaysia (MY)               Malaysia
lk    Sri Lanka (LK)              Sri Lanka
pk    Pakistan (PK)               Pakistan
kz    Kazakhstan (KZ)             Kazakhstan
th    Thailand (TH)               Thailand
id    Indonesia (ID)              Indonesia
nz    New Zealand (NZ)            New Zealand
tw3   Taiwan (TW)                 Taiwan - 3
vn    Vietnam (VN)                Vietnam
mo    Macau (MO)                  Macau
kh    Cambodia (KH)               Cambodia
mn    Mongolia (MN)               Mongolia
la    Laos (LA)                   Laos
mm    Myanmar (MM)                Myanmar
np    Nepal (NP)                  Nepal
kg    Kyrgyzstan (KG)             Kyrgyzstan
uz    Uzbekistan (UZ)             Uzbekistan
bd    Bangladesh (BD)             Bangladesh
bt    Bhutan (BT)                 Bhutan
bnbr  Brunei Darussalam (BN)      Brunei
cato  Canada (CA)                 Canada - Toronto
cava                              Canada - Vancouver
cato2                             Canada - Toronto - 2
camo                              Canada - Montreal
mx    Mexico (MX)                 Mexico
br2   Brazil (BR)                 Brazil - 2
br                                Brazil
pa    Panama (PA)                 Panama
cl    Chile (CL)                  Chile
ar    Argentina (AR)              Argentina
bo    Bolivia (BO)                Bolivia
cr    Costa Rica (CR)             Costa Rica
co    Colombia (CO)               Colombia
ve    Venezuela (VE)              Venezuela
ec    Ecuador (EC)                Ecuador
gt    Guatemala (GT)              Guatemala
pe    Peru (PE)                   Peru
uy    Uruguay (UY)                Uruguay
bs    Bahamas (BS)                Bahamas
ro    Romania (RO)                Romania
im    Isle of Man (IM)            Isle of Man
esma  Spain (ES)                  Spain - Madrid
esba                              Spain - Barcelona
esba2                             Spain - Barcelona - 2
tr    Turkey (TR)                 Turkey
ie    Ireland (IE)                Ireland
is    Iceland (IS)                Iceland
no    Norway (NO)                 Norway
dk    Denmark (DK)                Denmark
be    Belgium (BE)                Belgium
fi    Finland (FI)                Finland
gr    Greece (GR)                 Greece
pt    Portugal (PT)               Portugal
at    Austria (AT)                Austria
am    Armenia (AM)                Armenia
pl    Poland (PL)                 Poland
lt    Lithuania (LT)              Lithuania
ee    Estonia (EE)                Estonia
cz    Czech Republic (CZ)         Czech Republic
ad    Andorra (AD)                Andorra
me    Montenegro (ME)             Montenegro
ba    Bosnia and Herzegovina (BA) Bosnia and Herzegovina
lu    Luxembourg (LU)             Luxembourg
hu    Hungary (HU)                Hungary
bg    Bulgaria (BG)               Bulgaria
by    Belarus (BY)                Belarus
ua    Ukraine (UA)                Ukraine
mt    Malta (MT)                  Malta
li    Liechtenstein (LI)          Liechtenstein
cy    Cyprus (CY)                 Cyprus
al    Albania (AL)                Albania
hr    Croatia (HR)                Croatia
si    Slovenia (SI)               Slovenia
sk    Slovakia (SK)               Slovakia
mc    Monaco (MC)                 Monaco
je    Jersey (JE)                 Jersey
mk    North Macedonia (MK)        North Macedonia
md    Moldova (MD)                Moldova
rs    Serbia (RS)                 Serbia
ge    Georgia (GE)                Georgia
za    South Africa (ZA)           South Africa
il    Israel (IL)                 Israel
eg    Egypt (EG)                  Egypt
ke    Kenya (KE)                  Kenya
dz    Algeria (DZ)                Algeria
```