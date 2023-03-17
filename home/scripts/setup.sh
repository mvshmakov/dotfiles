#! /usr/bin/env bash

xcode-select --install

# Creating XDG Base Directory folders
mkdir -p "${XDG_CONFIG_HOME:=$HOME/.config}"
mkdir -p "${XDG_CACHE_HOME:=$HOME/.cache}"
mkdir -p "${XDG_DATA_HOME:=$HOME/.local/share}"
mkdir -p "${XDG_STATE_HOME:=$HOME/.local/state}"

# Directory is required to be present for compinit dumps
mkdir -p "${XDG_CACHE_HOME:=$HOME/.cache}"/zsh/
# Directory is required to create a ZSH history file
mkdir -p "${XDG_DATA_HOME:=$HOME/.local/share}"/zsh/

# Running main scripts
./macos.sh
./brew.sh
./shell.sh
./symlinks.sh

# Install NIX
sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume --daemon

echo "Setup completed!"
