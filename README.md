# My dotfiles

## Prerequisites

* [Adobe - Source Code Pro](https://github.com/adobe/Source-Code-Pro/downloads) font
* [brew](http://brew.sh/)
* oh-my-zsh

## Installation

```
git clone https://github.com/manuelvanrijn/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./setup_osx.sh
rake
```

## http ssl localhost

```
mkdir -p ~/.ssl
openssl req -newkey rsa:2048 -x509 -nodes -keyout ~/.ssl/localhost.key -new -out ~/.ssl/localhost.crt -subj /CN=localhost -reqexts SAN -extensions SAN -config <(cat /System/Library/OpenSSL/openssl.cnf <(printf '[SAN]\nsubjectAltName=DNS:localhost')) -sha256 -days 3650
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ~/.ssl/localhost.crt
``` 

#### Quicklook plugins

see: [quick-look-plugins](https://github.com/sindresorhus/quick-look-plugins)
