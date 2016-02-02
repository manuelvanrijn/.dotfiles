# My (cross)platform dotfiles

## Prerequisites

* [Adobe - Source Code Pro](https://github.com/adobe/Source-Code-Pro/downloads) font
* ImageMagick - `brew install imagemagick`

## Installation

```
git clone https://github.com/manuelvanrijn/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
rake
```

#### Quicklook plugins

see: [quick-look-plugins](https://github.com/sindresorhus/quick-look-plugins)

## Terminal extensions/commands
**disable motion sensor for ssd**

    sudo pmset -a sms 0

**unhide library folder for user**

    chflags nohidden ~/Library

**expand save panel by default**

    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true && \
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

**meta data on network and external devices**

    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

**enable airdrop over ethernet**

    defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

**software update interval from 1 week to 1 day**

    defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
