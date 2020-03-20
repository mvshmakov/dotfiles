# dotfiles
Dotfiles for macOS (relevant for Catalina 10.15+)

# Setup

```
sudo softwareupdate -i -a
cd ~ && git clone https://github.com/mvshmakovmv/dotfiles.git
cd dot-files && git submodule update --init --recursive
./scripts/setup.sh
```

# Useful commands

##### 1) Dump all of the installed brew packages: `brew list > packages.txt`
##### 2) Dump all of the installed brew casks: `brew cask list > casks.txt`

# Useful links

- [iterm2](https://iterm2.com)
- [homebrew](https://brew.sh)
- [tmux](https://github.com/tmux/tmux)
- [tmuxinator](https://github.com/tmuxinator/tmuxinator)
- [webvim](https://github.com/vim-dist/webvim)
