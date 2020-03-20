#!/bin/sh

# Links dotfiles with home folder
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.curlrc ~/.curlrc
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.gitignore ~/.gitignore
ln -s ~/dotfiles/.gitignore_global ~/.gitignore_global
ln -s ~/dotfiles/.gitmodules ~/.gitmodules
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf

ln -s ~/dotfiles/.tmuxinator ~/.tmuxinator
ln -s ~/dotfiles/shell-sources ~/shell-sources

ln -s ~/dotfiles/tmux-inactive-panes ~/tmux-inactive-panes
ln -s ~/dotfiles/tmux-tomorrow ~/tmux-tomorrow

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
