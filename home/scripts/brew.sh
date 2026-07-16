#!/usr/bin/env bash
#
# Initial brew setup + packages-related things

# Unofficial Bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# Official installer (the old ruby-based one was removed upstream and aborts)
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# The installer does not touch the current shell's PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

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
# (`brew bundle` is built into brew since 4.x; the homebrew/bundle tap is
# deprecated and tapping it fails)
HOMEBREW_CASK_OPTS="--adopt" brew bundle install --file ~/.config/brew/Brewfile
brew upgrade --cask --force

# Transferring libs for zathura: https://github.com/zegervdv/homebrew-zathura#installation
# `-f` keeps re-runs idempotent (plain `ln -s` fails under `set -e` if the link exists)
mkdir -p "$(brew --prefix zathura)"/lib/zathura
ln -sf "$(brew --prefix zathura-djvu)"/libdjvu.dylib "$(brew --prefix zathura)"/lib/zathura/libdjvu.dylib
ln -sf "$(brew --prefix zathura-pdf-poppler)"/libpdf-poppler.dylib "$(brew --prefix zathura)"/lib/zathura/libpdf-poppler.dylib

# Cleaning all brew intermediate staff
brew cleanup
brew autoremove

echo "Brew setup completed!"
