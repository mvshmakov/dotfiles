#!/bin/sh

xcode-select —-install

# Creating XDG_CONFIG_HOME
mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}

ssh-keygen -t rsa

# Running main scripts
./macos.sh
./brew.sh
./shell.sh

nvm install --lts --latest-npm --reinstall-packages-from='lts/*'
echo "NodeJS setup completed!"

./symlinks.sh

echo "Setup completed!"
