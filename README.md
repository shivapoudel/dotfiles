# Dotfiles

This repository contains machine-specific configuration to accompany my dotfiles.

## Installation

__Please Note:__ Run Git Bash terminal as administrator before executing below commands.

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

## Contents

### Profiles

```
meta/profiles/
└── workstation
```
### Dotbot configurations

```
meta/configs/
├── git.yaml
├── npm.yaml
├── local.yaml
├── shell.yaml
└── vscode.yaml
```

# License

Copyright (c) 2020 Shiva Poudel | Licensed under [MIT license](http://shivapoudel.mit-license.org)
