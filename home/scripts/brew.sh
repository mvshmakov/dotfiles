#!/usr/bin/env bash
#
# Initial brew setup + packages-related things

# Unofficial Bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# Official installer (the old ruby-based one was removed upstream and aborts)
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# The installer does not touch the current shell's PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

# Package management moved to nix-darwin: taps (with their trust entries),
# formulae, casks and Mac App Store apps are declared in
# nix-darwin/.config/nix-darwin/modules/darwin/homebrew.nix and installed by
# `brew bundle` during `darwin-rebuild switch` (see ./nix.sh). Homebrew itself
# must exist beforehand, which is all this script ensures now.

echo "Homebrew installed. Packages are installed by darwin-rebuild (./nix.sh)."
