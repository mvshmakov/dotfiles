# dotfiles
Dotfiles for macOS (relevant for Catalina 10.15+)

# Setup

```
sudo softwareupdate -i -a
cd ~/projects && git clone https://github.com/mvshmakov/dotfiles.git
cd dotfiles && git submodule update --init --recursive
./scripts/setup.sh
```

Iterm2's `com.googlecode.iterm2.plist` is in `$HOME` folder, so you need to set it also in iterm2 settings in order to load it.

# Useful commands

##### 1) Dump all of the installed brew packages: `brew list > packages.txt`
##### 2) Dump all of the installed brew casks: `brew cask list > casks.txt`

# Useful links

- [awesome-dotfiles](https://github.com/webpro/awesome-dotfiles)
- [iterm2](https://iterm2.com)
- [homebrew](https://brew.sh)
- [tmux](https://github.com/tmux/tmux)
- [tmuxinator](https://github.com/tmuxinator/tmuxinator)
- [webvim](https://github.com/vim-dist/webvim)
