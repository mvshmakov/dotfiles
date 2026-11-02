#!/usr/bin/env bash
#
# Install Determinate Nix and activate the nix-darwin configuration.
# Runbook: nix-darwin/.config/nix-darwin/README.md

# Unofficial Bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# The flake lives in this repository; the ~/.config/nix-darwin symlink is one
# of the links home-manager creates, so it cannot be relied on before the
# first switch
flake="$(cd "$(dirname "$0")/../../nix-darwin/.config/nix-darwin" && pwd)"

# Lets a bare `sudo darwin-rebuild switch` find the flake afterwards
if [[ ! -e /etc/nix-darwin ]]; then
  sudo ln -s "$flake" /etc/nix-darwin
fi

# Determinate Nix (daemon, flakes enabled, self-upgrading). macOS users -
# nix-darwin ones included - are told to use the graphical .pkg installer:
# https://docs.determinate.systems/determinate-nix/#installing-on-macos
if ! command -v nix >/dev/null 2>&1; then
  pkg="$(mktemp -d)/Determinate.pkg"
  curl -fsSL --proto '=https' --tlsv1.2 -o "$pkg" \
    "https://install.determinate.systems/determinate-pkg/stable/Universal"
  echo "Installing Determinate Nix (requires an administrator password)..."
  sudo installer -pkg "$pkg" -target /
  # The installer does not touch the current shell
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# First activation: darwin-rebuild is not on PATH yet, so run it from the
# pinned nix-darwin release. Subsequent runs: `make nix-switch`.
if command -v darwin-rebuild >/dev/null 2>&1; then
  sudo darwin-rebuild switch --flake "$flake"
else
  sudo nix run 'nix-darwin/nix-darwin-26.05#darwin-rebuild' -- switch --flake "$flake"
fi

echo "nix-darwin activated!"
