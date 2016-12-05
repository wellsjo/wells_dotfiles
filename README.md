# Dotfiles
My portable dev environment (OSX, Linux)

## Install
```bash
(
  git clone git@github.com:wellsjo/dotfiles.git ~/.dotfiles; 
  source ~/.dotfiles/bash/profile; 
  install_dotfiles; 
  vim +PlugInstall +qall +silent;
)
```

## Features
- vim config
- tmux config
- git config
- git auto-completion
- ssh auto-completion
- liquid shell prompt
- OSX start script

## Special Commands
SSH into remote server and auto-install dotfiles
```
sshw <host>
```
Udpate dotfiles and submodules
```
wupdate
```

# Dependencies
- tmux
- exuberant-ctags
