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

## Install default versions:

```
# Install (default) ruby
mkdir -p ~/.rubies
ruby-build 2.3.1 ~/.rubies/ruby-2.3.1
echo '2.3.1' > ~/.ruby-version

# Install node version
nvm install stable
nvm alias default stable

# Install crystal version
crenv install 0.23.1
crenv global 0.23.1
```

#### Quicklook plugins

see: [quick-look-plugins](https://github.com/sindresorhus/quick-look-plugins)
