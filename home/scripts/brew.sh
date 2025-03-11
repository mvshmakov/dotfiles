#!/usr/bin/env bash
#
# Initial brew setup + packages-related things

# Unofficial Bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install brew packages and casks
brew tap homebrew/bundle
brew bundle install --file ~/.config/brew/Brewfile

# Transferring libs for zathura: https://github.com/zegervdv/homebrew-zathura#installation
mkdir -p "$(brew --prefix zathura)"/lib/zathura
ln -s "$(brew --prefix zathura-djvu)"/libdjvu.dylib "$(brew --prefix zathura)"/lib/zathura/libdjvu.dylib
ln -s "$(brew --prefix zathura-pdf-poppler)"/libpdf-poppler.dylib "$(brew --prefix zathura)"/lib/zathura/libpdf-poppler.dylib

# GNU core utilities are installed (those that come with macOS are outdated).
ln -s "$(brew --prefix)/bin/gsha256sum" "$(brew --prefix)/usr/bin/env sha256sum"

# Cleaning all brew intermediate staff
brew cleanup
brew autoremove

echo "Brew setup completed!"
