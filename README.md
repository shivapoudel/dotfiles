Dotfiles
========

> This repository contains machine-specific configuration to accompany my dotfiles.

After cloning this repo, run `install` to automatically set up the dotfiles development
environment. Note that the install script is idempotent: it can safely be run multiple times.

__Please Note:__ Dotfiles uses [config_curator](https://rubygems.org/gems/config_curator) gem for installation.

Install
-------

```bash
git clone --recursive git@github.com:shivapoudel/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

License
-------

Copyright (c) 2015 Shiva Poudel  
Licensed under the MIT license:  
<http://shivapoudel.mit-license.org/>
