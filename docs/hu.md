# Palyanytsya

Készen álltok egy újabb támadáshoz?

## Mi ez?
Ez egy util szerverek tömeges tesztjeihez VPN-n keresztül dinamikus konténerekkel.

## Feltételek?

- Akármilyen számítógép dockerrel
- ExpressVPN
- Ügyes kezek
- Fantázia

***
S3, Azure, Digital Ocean platformokon is futtatható.

## Használat

**Klónolni a repot:**

```bash
git clone https://github.com/wallwhite/Palyanytsya.git
```

**Nyisd meg a mappát:**

```bash
cd ./Palyanytsya
```

**Inicializálás:**

```bash
bash init.sh
```

## Könnyü kezdet

**Az indításhoz:**

```bash
bash start.sh
```

Az alábbi argumentumokkal indíthato a terminálból:

- `-q` - Konténerek száma
- `-c` - ExpressVPN kód
- `-help` , `-h` - Súgó

Lépésről lépésre is megadható ezek az adatok elinditva a `bash start.sh` a fent említett argumentumokon kívül.

A VPN régió autómatikusan választódik és időről időre változik.

A teszt target - egyike az adatbázisunkban lévő target listának.

Elég egyszer elindítania, ezzel nagy segítségére lesz a kiber biztonságunk garantálásában.

A target adatbázisunkat rövid időn belül publikálni fogjuk.

***

**Parancsok (Példák):**

```bash
bash start.sh -c ffu34hsdf8ee4nfsdn34nsfd -q 10
```

Ahol `ffu34hsdf8ee4nfsdn34nsfd` — ExpressVPN kód `10` konténerek száma

### Parancsok

**Indítás:**

```bash
bash start.sh
```

**Leállítás:**

```bash
bash stop.sh
```

**Példa:**

```bash
bash start.sh -q 1 -q fsdf342jnnsjnjr3n
```

## Contributing

**Ha szeretnétek segíteni - készíts `pull request` és küld az észrevételeidet.**
