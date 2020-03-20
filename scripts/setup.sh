#!/bin/sh

xcode-select —-install

# Creating XDG_CONFIG_HOME
mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}

ssh-keygen -t rsa

# Running main scripts
./macos.sh
./brew.sh

# Installing oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
upgrade_oh_my_zsh

chmod 744 ~/.oh-my-zsh/oh-my-zsh.sh
chsh -s $(which zsh)

# Setting iterm2 integration with zsh
curl -L https://iterm2.com/shell_integration/zsh \
-o ~/.iterm2_shell_integration.zsh

# Continue running main scripts
./node.sh
./symlinks.sh

echo "Setup completed!"
