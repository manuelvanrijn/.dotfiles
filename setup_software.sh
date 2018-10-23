#!/usr/bin/env bash

################
# PACKAGES
################

echo "Installing asdf-vm"
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.4.0
source asdf/asdf.zsh
asdf plugin-list-all >> /dev/null
asdf plugin-add crystal
asdf plugin-add golang
asdf plugin-add nodejs
asdf plugin-add ruby
asdf plugin-add python
asdf plugin-update --all

echo "Install brew packages"
brew tap homebrew/services
brew tap wallix/awless
cat brew_packages | xargs brew install
brew link --force mysql@5.7

echo "Install cask packages"
brew tap caskroom/cask
brew tap caskroom/versions
cat cask_packages | xargs brew cask install

reload!

# Remove Dropbox’s green checkmark icons in Finder
file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns
[ -e "${file}" ] && mv -f "${file}" "${file}.bak"

echo "Install vagrant plugin(s)"
vagrant plugin install vagrant-cachier vagrant-vbguest

echo "Install zsh plugin(s)"
cd ~/.oh-my-zsh/custom/plugins
git clone https://github.com/iam4x/zsh-iterm-touchbar.git

echo "Install vscode plugins"
~/.dotfiles/vscode/install.sh

# Setup settings
ln -s ~/.dotfiles/settings/itsyscal/preferences.plist ~/Library/Preferences/com.mowglii.ItsycalApp.plist
