<p align="center">
  <img src="https://www.alchemists.io/images/projects/mac_os-config/icon.png" alt="MacOS Config Icon"/>
</p>

# dotfiles

Dotfiles for macOS (relevant for Catalina 10.15+)

# Setup

```
sudo softwareupdate -i -a
mkdir -p ~/projects/personal
cd ~/projects/personal && git clone https://github.com/mvshmakov/dotfiles.git
cd dotfiles && git submodule update --init --recursive
stow --stow -vt ~ */
```

To restow/repair the symlinks, use `stow --restow -vt ~ */`. To simulate the stow process outcome without modifying the filesystem, use `stow --stow --no -vt ~ */`. `*/` is the ZSH glob which expands only in the folders.

If you want to add the submodule, consider running `git submodule add --name {name} https://github.com/{author}/{name}.git {tool}/.config/{tool}/{name}` instead of just adding the corresponding submodule definition in the `.gitmodules`.

ITerm2's `com.googlecode.iterm2.plist` is in `$HOME` folder, so you need to set it also in ITerm2 settings in order to load it.

# Useful commands

##### 1) Dump all of the installed brew packages: `brew list > packages.txt`

##### 2) Dump all of the installed brew casks: `brew list --cask > casks.txt`

##### 3) Dump all vscode extensions to shell commands: `code --list-extensions | xargs -L 1 echo code --install-extension`

##### 4) `stow --restow {folder}`

# Z-based navigation

#### `z {pattern}[TAB]` will expand the path Z detected

# Comments for packages in the `brew` folder

- `ql` is an alias for a quick look MacOS files feature.
- `bat` is a good alternative to `cat` for `JSON` files.

If you want your current system configuration to match your Brewfile

`brew bundle --force cleanup`

# Useful links

- [awesome-dotfiles](https://github.com/webpro/awesome-dotfiles)
- [zsh-users](https://github.com/zsh-users)
- [alacritty](https://github.com/alacritty/alacritty)
- [homebrew](https://brew.sh)
- [tmux](https://github.com/tmux/tmux)
- [tmuxinator](https://github.com/tmuxinator/tmuxinator)
- [webvim](https://github.com/vim-dist/webvim)

# Literature

- [Colours in terminal](https://gist.github.com/XVilka/8346728#true-color-detection)
- ["\[WTF IS \033\[30;47m???", a practical cheat-sheet](https://gist.github.com/DNA/ebb9258089e9e1dfd08c58695b3cd6f1)
