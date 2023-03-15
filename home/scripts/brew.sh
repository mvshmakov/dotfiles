#!/usr/bin/env bash

# Unofficial Bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update && brew upgrade

# Save Homebrew's installed location.
BREW_PREFIX=$(brew --prefix)

# Brew aliases ability
brew tap homebrew/aliases
# Brew casks extended ability
brew tap homebrew/cask-versions
# Yubikey manager, etc.
brew tap homebrew/cask-drivers
# Font casks
brew tap homebrew/cask-fonts
# Brew bundle
brew tap homebrew/bundle

# Heroku casks
brew tap heroku/brew
# PDR and other docs reader
brew tap zegervdv/zathura

# Install brew packages and casks
xargs brew install <../brew/packages.txt
xargs brew install --cask <../brew/casks.txt

# Transferring libs for zathura: https://github.com/zegervdv/homebrew-zathura#installation
mkdir -p "$(brew --prefix zathura)"/lib/zathura
ln -s "$(brew --prefix zathura-djvu)"/libdjvu.dylib "$(brew --prefix zathura)"/lib/zathura/libdjvu.dylib
ln -s "$(brew --prefix zathura-pdf-poppler)"/libpdf-poppler.dylib "$(brew --prefix zathura)"/lib/zathura/libpdf-poppler.dylib

# GNU core utilities are installed (those that come with macOS are outdated).
# Don't forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/usr/bin/env sha256sum"

# Cleaning all brew intermediate staff
brew cleanup
brew autoremove

echo "Brew setup completed!"
