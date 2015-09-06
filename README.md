Dotfiles
========

> This repository contains machine-specific configuration to accompany my dotfiles.

After cloning this repo, run `$ curate -v` to automatically set up the dotfiles.
Note that the install script is idempotent: it can safely be run multiple times.

Dotfiles uses [config_curator](https://rubygems.org/gems/config_curator) gem for installation.

Install
-------

Install the `config_curator` gem (make sure installed gem binaries are in your PATH).

```bash
git clone git@github.com:shivapoudel/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
$ curate -v
```

License
-------

Copyright (c) 2015 Shiva Poudel  
Licensed under the MIT license:  
<http://shivapoudel.mit-license.org/>
