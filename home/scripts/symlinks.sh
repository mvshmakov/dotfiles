#! /usr/bin/env sh

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
