#!/usr/bin/env bash

# Unofficial Bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# Only change the login shell when it differs (chsh prompts for a password)
if [ "$SHELL" != "$(command -v zsh)" ]; then
  chsh -s "$(command -v zsh)"
fi

# Select dash as the default POSIX-compliant shell (#!/usr/bin/env sh).
# Not a direct symlink to /usr/bin/env sh due it is a symlink for /var/select/sh https://mckern.sh/post/bash-by-the-numbers/
# Improves sh performance https://unix.stackexchange.com/questions/148035/is-dash-or-some-other-shell-faster-than-bash
case "$OSTYPE" in
  darwin*) sudo ln -sf /bin/dash /var/select/sh ;;
  *) echo "Skipping /bin/sh switch: only implemented for macOS" ;;
esac

# Key repeat rate is configured in macos.sh via `defaults write -g KeyRepeat`
# (xset is an X11 tool and does not exist on macOS)
