#!/usr/bin/env bash
#
# Full machine bootstrap: run from anywhere, e.g. ./home/scripts/setup.sh

# Unofficial Bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# The sub-scripts are invoked by relative path, so run from this directory
cd "$(dirname "$0")"

# Command Line Tools: `--install` is asynchronous (opens a GUI dialog) and
# errors out when the tools are already present, so guard and re-run
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo "Command Line Tools installation started - re-run this script once it finishes."
  exit 1
fi

# Creating XDG Base Directory folders
mkdir -p "${XDG_CONFIG_HOME:=$HOME/.config}"
mkdir -p "${XDG_CACHE_HOME:=$HOME/.cache}"
mkdir -p "${XDG_DATA_HOME:=$HOME/.local/share}"
mkdir -p "${XDG_STATE_HOME:=$HOME/.local/state}"

# Directory is required to be present for compinit dumps
mkdir -p "$XDG_CACHE_HOME"/zsh/
# Directory is required to create a ZSH history file
mkdir -p "$XDG_DATA_HOME"/zsh/

# Running main scripts
# macOS defaults not expressible in nix-darwin (the rest is in
# nix-darwin/.config/nix-darwin/modules/darwin/system.nix)
./macos.sh
# Installs Homebrew itself only; packages, casks and App Store apps are
# declared in nix-darwin and installed by `darwin-rebuild switch`
./brew.sh
# Installs Determinate Nix and activates the nix-darwin configuration
# (requires the stow symlinks, in particular ~/.config/nix-darwin)
./nix.sh
./shell.sh
./symlinks.sh
# Requires the stow symlinks (plists) and the brew packages to be in place
./services.sh
# Requires the claude-code cask, node (mise), uv and atuin (nix) from the steps above
./claude.sh

echo "Setup completed!"
