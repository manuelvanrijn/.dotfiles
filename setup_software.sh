#!/usr/bin/env bash

################
# PACKAGES
################

echo "Installing asdf-vm"
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
cd ~/.asdf
git checkout "$(git describe --abbrev=0 --tags)"
cd ~/.dotfiles
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
brew tap homebrew/cask
brew tap homebrew/cask-versions
brew tap homebrew/cask-drivers
cat brew_packages | xargs brew install
brew link --force mysql@5.7
# enable fzf
$(brew --prefix)/opt/fzf/install

reload!

# Remove Dropbox’s green checkmark icons in Finder
file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns
[ -e "${file}" ] && mv -f "${file}" "${file}.bak"

echo "Install vagrant plugin(s)"
vagrant plugin install vagrant-cachier vagrant-vbguest

# Setup settings
ln -s ~/.dotfiles/settings/itsyscal/preferences.plist ~/Library/Preferences/com.mowglii.ItsycalApp.plist

# Setup gpg config
mkdir -p ~/.gnupg
rm ~/.gnupg/gpg.conf
ln -s ~/.dotfiles/gnupg/gpg.conf.symlink ~/.gnupg/gpg.conf

# Setup git diff
mkdir -p ~/.bin
ln -s /usr/local/share/git-core/contrib/diff-highlight/diff-highlight ~/.bin/diff-highlight
