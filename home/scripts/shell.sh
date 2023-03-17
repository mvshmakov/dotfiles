#!/usr/bin/env bash

# Unofficial Bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# Installing oh-my-zsh
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
compaudit | xargs chmod g-w,o-w
upgrade_oh_my_zsh

chsh -s "$(which zsh)"
# Select dash as the default POSIX-compiant shell (#!/usr/bin/env sh)
# Not a direct symlink to /usr/bin/env sh due it is a symlink for /var/select/sh https://mckern.sh/post/bash-by-the-numbers/
# Impoves sh perfomance https://unix.stackexchange.com/questions/148035/is-dash-or-some-other-shell-faster-than-bash
case "$OSTYPE" in
darwin*) sudo ln -sf /bin/dash /var/select/sh ;;
*) sudo ln -sfT dash /usr/usr/bin/env sh ;;
esac

# Setting iterm2 integration with zsh
curl -L https://iterm2.com/shell_integration/zsh \
	-o ~/.oh-my-zsh/custom/plugins/.iterm2_shell_integration.zsh

# Installing custom plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone git://github.com/l4u/zsh-output-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-output-highlighting

# Permissions for .oh-my-zsh directory
sudo chown -R "$USER":admin ~/.oh-my-zsh

# Increase key speed via a rate change
xset r rate 300 50
