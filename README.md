Dotfiles
========

> This repository contains machine-specific configuration to accompany my dotfiles.

After cloning this repo, run `curate -v` to automatically set up the dotfiles development
environment. Note that the install script is idempotent: it can safely be run multiple times.

__Please Note:__ Dotfiles uses [config_curator](https://rubygems.org/gems/config_curator) gem for installation.

Install
-------

```bash
git clone --recursive https://github.com/shivapoudel/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
curate -v
./vim-plugins
./bin/{phploy|phpunit|wp-cli}-install
```

__Please Note:__ For Windows add `{git_installation_path}/usr/local/bin/` directory to PATH using [Path Editor](https://patheditor2.codeplex.com/) tool.

License
-------

Copyright (c) 2015 Shiva Poudel  
Licensed under the MIT license:  
<http://shivapoudel.mit-license.org/>
