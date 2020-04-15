#!/bin/bash

# Install brew and update
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update && brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install brew packages and casks
xargs brew install < ../brew/packages.txt
xargs brew cask install < ../brew/casks.txt

# Brew aliases ability
brew tap homebrew/aliases
# Brew casks ability
brew tap homebrew/cask

# GNU core utilities are installed (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Cleaning all brew intermediate staff
brew cleanup

echo "Brew setup completed!"
