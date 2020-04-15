#!/bin/sh

# Installing oh-my-zsh
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
compaudit | xargs chmod g-w,o-w
upgrade_oh_my_zsh

chsh -s $(which zsh)

# Setting iterm2 integration with zsh
curl -L https://iterm2.com/shell_integration/zsh \
-o ~/.oh-my-zsh/custom/plugins/.iterm2_shell_integration.zsh

# Installing custom plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone git://github.com/l4u/zsh-output-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-output-highlighting

# Permissions for cache directory
sudo chown -R $USER:staff "$ZSH_CACHE_DIR"
