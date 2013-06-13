# My (cross)platform dotfiles

## Prerequisites

* [Adobe - Source Code Pro](https://github.com/adobe/Source-Code-Pro/downloads) font

### Windows

- [python27](http://www.python.org/download/) **32bits** and [pygtk-all-in-one](http://www.pygtk.org/downloads.html) **note: the all in one**
- [meld](https://live.gnome.org/Meld/Windows) installed into "c:\Program Files (x86)\meld"

## Installation

### Windows

```
git clone https://github.com/manuelvanrijn/.dotfiles.git c:\.dotfiles
cd c:\.dotfiles
rake
```

#### Meld

It could be Meld isn't working out of the box because we use it on Windows. If you get te following error you have to change the `bin/meld` file:

```
/bin/env: python: No such file or directory
```

If so, change the following line in `bin/meld`

`#! /usr/bin/env python` into `#!c:/Python27/python.exe`

### OSX

```
git clone https://github.com/manuelvanrijn/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
rake
```
