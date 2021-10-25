#! /usr/bin/env sh

xcode-select --install

# Creating XDG_CONFIG_HOME
mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
mkdir -p ${XDG_CACHE_HOME:=$HOME/.cache}

ssh-keygen -t rsa

# Running main scripts
./macos.sh
./brew.sh
./shell.sh
./symlinks.sh

# Install NIX
sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume --daemon

# Installing NodeJS LTS
nvm install --lts --latest-npm --reinstall-packages-from='lts/*'
echo "NodeJS setup completed!"

echo "Setup completed!"
