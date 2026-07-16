#!/usr/bin/env sh
#
# Symlink configs that live outside stow's reach (app-specific locations).
# Idempotent: safe to re-run; existing real files are backed up once.
#
# Note: iTerm2's plist is NOT handled here anymore - the iterm2/ stow
# package ships Library/Preferences/com.googlecode.iterm2.plist, so plain
# `stow iterm2` covers it.

set -eu
IFS=$(printf '\n\t')

# link_config <source> <destination>
# Skips when the source is missing (config not versioned yet) or the
# destination's parent is missing (app not installed), backs up a
# pre-existing real file, and (re)points the symlink at the source.
link_config() {
  src="$1"
  dest="$2"

  if [ ! -e "$src" ]; then
    echo "skip: source $src does not exist (not versioned yet?)"
    return 0
  fi

  if [ ! -d "$(dirname "$dest")" ]; then
    echo "skip: $(dirname "$dest") does not exist (app not installed?)"
    return 0
  fi

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "$dest.backup"
    echo "backed up: $dest -> $dest.backup"
  fi

  ln -sfn "$src" "$dest"
  echo "linked: $dest -> $src"
}

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

## VSCode (ordinary + Insiders)
# Sources are expected at $XDG_CONFIG_HOME/vscode; the links activate
# automatically once the settings are versioned there
for variant in "Code" "Code - Insiders"; do
  link_config "$XDG_CONFIG_HOME/vscode/settings.json" \
    "$HOME/Library/Application Support/$variant/User/settings.json"
  link_config "$XDG_CONFIG_HOME/vscode/keybindings.json" \
    "$HOME/Library/Application Support/$variant/User/keybindings.json"
done

echo 'All of the symlinks created!'
