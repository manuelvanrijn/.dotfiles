#!/usr/bin/env bash

################
# PACKAGES
################

echo "Install brew packages"
brew bundle install
# enable fzf
$(brew --prefix)/opt/fzf/install

reload!

# Remove Dropbox’s green checkmark icons in Finder
file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns
[ -e "${file}" ] && mv -f "${file}" "${file}.bak"

echo "Install vagrant plugin(s)"
vagrant plugin install vagrant-cachier vagrant-vbguest

# Setup gpg config
mkdir -p ~/.gnupg
rm ~/.gnupg/gpg.conf
ln -s ~/.dotfiles/gnupg/gpg.conf.symlink ~/.gnupg/gpg.conf

# mise
ln -s ~/.dotfiles/mise/.config/mise ~/.config
