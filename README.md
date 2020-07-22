# Dotfiles

This repository contains machine-specific configuration to accompany my dotfiles.

### Installation

__Please Note:__ Run Git Bash terminal as administrator before executing below commands.

```bash
npm config set tmp ~/.tmp-npm # Setup NPM tmp config.
sh -c "$(curl -fsSL https://raw.githubusercontent.com/shivapoudel/dotfiles/master/rsync/install.sh)" # Setup rsync
powershell "$(curl -fsSL https://raw.githubusercontent.com/shivapoudel/dotfiles/master/git/install.ps1)" # Setup git
powershell "$(curl -fsSL https://raw.githubusercontent.com/shivapoudel/dotfiles/master/local/install.ps1)" # Setup local
```

# License

Copyright (c) Shiva Poudel. All rights reserved.

Licensed under the [MIT](http://shivapoudel.mit-license.org) license.
