# dotfiles

![macOS Config Icon](https://www.alchemists.io/images/projects/mac_os-config/icon.png "macOS Config Icon")

Dotfiles for macOS (relevant for Catalina 10.15+)

## Setup

```bash
sudo softwareupdate -i -a

mkdir -p ~/projects/personal && cd ~/projects/personal
git clone https://github.com/mvshmakov/dotfiles.git && cd dotfiles

git submodule update --recursive --init
stow --stow -vt ~ */

./home/scripts/setup.sh
```

To restow/repair the symlinks, use `stow --restow -vt ~ */`. To simulate the stow process outcome without modifying the filesystem, use `stow --stow --no -vt ~ */`. `*/` is the ZSH glob, which expands only in the folders.

If you want to add the submodule, consider running `git submodule add --name {name} https://github.com/{author}/{name}.git {tool}/.config/{tool}/{name}` instead of just adding the corresponding submodule definition in the `.gitmodules`. If you want to delete the submodule, see [delete_git_submodule.md](https://gist.github.com/myusuf3/7f645819ded92bda6677?permalink_comment_id=2696221#gistcomment-2696221).

ITerm2's `com.googlecode.iterm2.plist` is in the `$HOME` folder, so you need to set it also in ITerm2 settings to load it.

The last step would be to generate new SSH key pair and add it to the required services.

One should also enable the `Reduced motion` option in the `System Preferences` to increase the speed of window/desktop switching.

## Useful commands

1. Dump all of the installed brew packages: `brew list > packages.txt`
2. Dump all of the installed brew casks: `brew list --cask > casks.txt`
3. Dump all vscode extensions to shell commands: `code --list-extensions | xargs -L 1 echo code --install-extension`
4. `stow --restow {folder}`

## Z-based navigation

- `z {pattern}[TAB]` will expand the path Z detected

## Comments for packages in the `brew` folder

- The `bat` is a good alternative to the `cat` for `JSON` files.

If you want your current system configuration to match your Brewfile (purge all non-fixed deps)

`brew bundle --force cleanup`

How to upgrade brew:

- `brew update` (update brew itself) is superseded by `brew autoupdate start --greedy`
- `brew upgrade --greedy` update all the packages together with :latest and :auto_update

## NeoVIM after stow

- Run `:Copilot setup`

## TODO

- Warn about exiting from the git commit message template on non-empty message
- If possible, simplify the GPG signature sign in git log to make it smaller but still present
- Use `markdownlint` for the documentation
- Run `prettier` on `md`/`yml`/etc. on pre-commit
- Use `shfmt` + `shellcheck` + `checkbashisms` on scripts from dotfiles + document it
- Align all shell scripts with Google shell scripting guidelines + apply all the linting
- Run CI with pre-commit hooks
- Use `git subtree` instead of `git module` to [manage dependencies](https://www.atlassian.com/git/tutorials/git-subtree)

## Useful links

- [awesome-dotfiles](https://github.com/webpro/awesome-dotfiles)
- [zsh-users](https://github.com/zsh-users)

## Literature

- [macOS Config](https://www.alchemists.io/mac-os-config/)]
- [Colors in terminal](https://gist.github.com/XVilka/8346728#true-color-detection)
- [ANSI Escape Sequences](https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797)
- ["\[WTF IS \033\[30;47m???", a practical cheat-sheet](https://gist.github.com/DNA/ebb9258089e9e1dfd08c58695b3cd6f1)
- [sudo insults](https://www.sudo.ws/posts/2019/11/which-sudo-users-to-insult-sudo-configuration-basics/#__enabling-insults__) - though for MacOS it is needed to [recompile](https://apple.stackexchange.com/questions/257405/how-do-i-install-sudo-insults-on-mac) the `sudo` binary to enable --with-all-insults
