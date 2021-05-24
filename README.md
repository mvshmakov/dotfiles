<p align="center">
  <img src="https://www.alchemists.io/images/projects/mac_os-config/icon.png" alt="MacOS Config Icon"/>
</p>

# dotfiles

Dotfiles for macOS (relevant for Catalina 10.15+)

# Setup

```
sudo softwareupdate -i -a
cd ~/projects && git clone https://github.com/mvshmakov/dotfiles.git
cd dotfiles && git submodule update --init --recursive
./scripts/setup.sh
```

ITerm2's `com.googlecode.iterm2.plist` is in `$HOME` folder, so you need to set it also in ITerm2 settings in order to load it.

# Useful commands

##### 1) Dump all of the installed brew packages: `brew list > packages.txt`

##### 2) Dump all of the installed brew casks: `brew list --cask > casks.txt`

##### 3) Dump all vscode extensions to shell commands: `code --list-extensions | xargs -L 1 echo code --install-extension`

# TODO:

##### 1) Add vim configuration

##### 2) XDG_CONFIG_DIR

# Comments for packages in `brew` folder

- `ql` is an alias for quick look MacOS files feature.
- `bat` is a good alternative to `cat` for `JSON` files.

# Useful links

- [awesome-dotfiles](https://github.com/webpro/awesome-dotfiles)
- [zsh-users](https://github.com/zsh-users)
- [iterm2](https://iterm2.com)
- [homebrew](https://brew.sh)
- [tmux](https://github.com/tmux/tmux)
- [tmuxinator](https://github.com/tmuxinator/tmuxinator)
- [webvim](https://github.com/vim-dist/webvim)

# Literature

- [Colours in terminal](https://gist.github.com/XVilka/8346728#true-color-detection)
- ["\[WTF IS \033\[30;47m???", a practical cheat-sheet](https://gist.github.com/DNA/ebb9258089e9e1dfd08c58695b3cd6f1)
