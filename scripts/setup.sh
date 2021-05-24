#! /usr/bin/env sh

xcode-select --install

# Creating XDG_CONFIG_HOME
mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}

ssh-keygen -t rsa

# Running main scripts
./macos.sh
./brew.sh
./shell.sh
./symlinks.sh

# Installing NodeJS LTS
nvm install --lts --latest-npm --reinstall-packages-from='lts/*'
echo "NodeJS setup completed!"

echo "Setup completed!"
