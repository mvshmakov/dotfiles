#! /usr/bin/env sh

# TODO: a good way to get rid of this file is to use XDG_CONFIG_DIR
DOTFILES_PATH="/Users/$USER/projects/dotfiles"

# Links dotfiles with home folder
rm ~/.zshrc; ln -s $DOTFILES_PATH/.zshrc ~/.zshrc
rm ~/.zprofile; ln -s $DOTFILES_PATH/.zprofile ~/.zprofile
rm ~/.curlrc; ln -s $DOTFILES_PATH/.curlrc ~/.curlrc
rm ~/.gitconfig; ln -s $DOTFILES_PATH/.gitconfig ~/.gitconfig
rm ~/.gitignore; ln -s $DOTFILES_PATH/.gitignore ~/.gitignore
rm ~/.gitignore_global; ln -s $DOTFILES_PATH/.gitignore_global ~/.gitignore_global
rm ~/.gitmodules; ln -s $DOTFILES_PATH/.gitmodules ~/.gitmodules
rm ~/.tmux.conf; ln -s $DOTFILES_PATH/.tmux.conf ~/.tmux.conf

rm -rf ~/.ssh; ln -s $DOTFILES_PATH/.ssh ~/.ssh
rm -rf ~/.tmuxinator; ln -s $DOTFILES_PATH/.tmuxinator ~/.tmuxinator

rm -rf ~/shell-sources; ln -s $DOTFILES_PATH/shell-sources ~/shell-sources
rm -rf ~/bin; ln -s /Users/mvshmakov/projects/dotfiles/bin ~/bin

ln -s $DOTFILES_PATH/.config/nvim ~/.config/nvim
ln -s $DOTFILES_PATH/.config/zathura ~/.config/zathura

ln -s $DOTFILES_PATH/tmux-inactive-panes ~/tmux-inactive-panes
ln -s $DOTFILES_PATH/tmux-tomorrow ~/tmux-tomorrow

cp $DOTFILES_PATH/iterm2/com.googlecode.iterm2.plist ~/com.googlecode.iterm2.plist

# Creation of projects and Yandex.Disk folders
if [ ! -d "~/projects" ]; then
    mkdir ~/projects
    echo "~/projects directory created"
else
    echo "~/projects already exists"
fi

if [ ! -d "~/Yandex.Disk.localized" ]; then
    mkdir ~/Yandex.Disk.localized
    echo "~/Yandex.Disk.localized directory created"
else
    echo "~/Yandex.Disk.localized already exists"
fi

# Creation of symlinks for projects and Yandex.Disk folders
if [ -L "~/Desktop/projects" ]; then
    if [ -e "~/Desktop/projects" ] ; then
        echo "Symlink already exists on Desktop!"
    else
        echo "Symlink \"~/Desktop/projects\" is broken!"
    fi
    elif [ -e "~/Desktop/projects" ] ; then
    echo "Something with name \"projects\" already exists on Desktop!"
else
    ln -s ~/projects ~/Desktop/projects
    echo "~/Desktop/projects symlink created"
fi

if [ -L "~/Desktop/Yandex.Disk" ]; then
    if [ -e "~/Desktop/Yandex.Disk" ] ; then
        echo "Symlink already exists on Desktop!"
    else
        echo "Symlink \"~/Desktop/Yandex.Disk\" is broken!"
    fi
    elif [ -e "~/Desktop/Yandex.Disk" ] ; then
    echo "Something with name \"Yandex.Disk\" already exists on Desktop!"
else
    ln -s ~/Yandex.Disk.localized ~/Desktop/Yandex.Disk
    echo "~/Desktop/Yandex.Disk symlink created"
fi

echo 'All of the symlinks created!'
