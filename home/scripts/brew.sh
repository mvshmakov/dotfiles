#!/usr/bin/env bash
#
# Initial brew setup + packages-related things

# Unofficial Bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Homebrew 6 refuses formulae from non-official taps unless they're explicitly
# trusted (HOMEBREW_REQUIRE_TAP_TRUST is on by default). Pre-trust every
# third-party tap the Brewfile pulls formulae from so the bundle install below
# runs non-interactively.
brew trust --tap \
  grafana/grafana \
  homebrew-zathura/zathura \
  theseal/ssh-askpass \
  asmvik/formulae \
  kaplanelad/tap \
  mvshmakov/spotlighter

# Install brew packages and casks.
# --adopt lets Homebrew take over apps already present in /Applications (e.g.
# installed manually before this ran) when they're identical to the cask;
# brew bundle honors it via the cask options env var. Version-drifted apps are
# handled by the explicit `brew upgrade --cask --force` in update-all (the env
# var is ignored by `brew upgrade`, so it can't help there).
brew tap homebrew/bundle
HOMEBREW_CASK_OPTS="--adopt" brew bundle install --file ~/.config/brew/Brewfile
brew upgrade --cask --force

# Transferring libs for zathura: https://github.com/zegervdv/homebrew-zathura#installation
mkdir -p "$(brew --prefix zathura)"/lib/zathura
ln -s "$(brew --prefix zathura-djvu)"/libdjvu.dylib "$(brew --prefix zathura)"/lib/zathura/libdjvu.dylib
ln -s "$(brew --prefix zathura-pdf-poppler)"/libpdf-poppler.dylib "$(brew --prefix zathura)"/lib/zathura/libpdf-poppler.dylib

# Cleaning all brew intermediate staff
brew cleanup
brew autoremove

echo "Brew setup completed!"
