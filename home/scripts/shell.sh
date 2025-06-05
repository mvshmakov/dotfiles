#!/usr/bin/env bash

# Unofficial Bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

chsh -s "$(which zsh)"

# Select dash as the default POSIX-compliant shell (#!/usr/bin/env sh)
# Not a direct symlink to /usr/bin/env sh due it is a symlink for /var/select/sh https://mckern.sh/post/bash-by-the-numbers/
# Improves sh performance https://unix.stackexchange.com/questions/148035/is-dash-or-some-other-shell-faster-than-bash

case "$OSTYPE" in
  darwin*) sudo ln -sf /bin/dash /var/select/sh ;;
  *) sudo ln -sfT dash /usr/usr/bin/env sh ;;
esac

# Increase key speed via a rate change
xset r rate 300 50
