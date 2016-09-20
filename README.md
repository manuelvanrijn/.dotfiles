# My (cross)platform dotfiles

## Prerequisites

* [Adobe - Source Code Pro](https://github.com/adobe/Source-Code-Pro/downloads) font
* [brew](http://brew.sh/)
* [iterm2](https://www.iterm2.com/)
* oh-my-zsh
* Sublime text 3

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

```
#### Quicklook plugins

see: [quick-look-plugins](https://github.com/sindresorhus/quick-look-plugins)
