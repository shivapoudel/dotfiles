# Dotfiles

> This repository contains machine-specific configuration to accompany my dotfiles.

# Installation

__Please Note:__ Use as administrator privilage within VS Code terminal.

```bash
git clone --recursive git@github.com:shivapoudel/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

For installing a predefined profile:
```bash
~/.dotfiles$ ./install-profile <profile> [<configs...>]
# see meta/profiles/ for available profiles
```

For installing single configurations:
```bash
~/.dotfiles$ ./install-standalone <configs...>
# see meta/configs/ for available configurations
```

You can run these installation commands safely multiple times, if you think that helps with better installation.

# License

Copyright (c) 2018 Shiva Poudel | Licensed under [MIT license](http://shivapoudel.mit-license.org)
