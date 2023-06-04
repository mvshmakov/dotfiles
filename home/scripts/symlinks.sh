#!/usr/bin/env sh
#
# Create some directories and symlinks

set -eu
IFS=$(printf '\n\t')

## Ordinary VSCode

mv ~/Library/Application\ Support/Code/User/settings.json ~/Library/Application\ Support/Code/User/settings.backup.json
ln -s "$XDG_CONFIG_HOME"/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json

mv ~/Library/Application\ Support/Code/User/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.backup.json
ln -s "$XDG_CONFIG_HOME"/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json

## VSCode Insiders

mv ~/Library/Application\ Support/Code\ -\ Insiders/User/settings.json ~/Library/Application\ Support/Code\ -\ Insiders/User/settings.backup.json
ln -s "$XDG_CONFIG_HOME"/vscode/settings.json ~/Library/Application\ Support/Code\ -\ Insiders/User/settings.json

mv ~/Library/Application\ Support/Code\ -\ Insiders/User/keybindings.json ~/Library/Application\ Support/Code\ -\ Insiders/User/keybindings.backup.json
ln -s "$XDG_CONFIG_HOME"/vscode/keybindings.json ~/Library/Application\ Support/Code\ -\ Insiders/User/keybindings.json

## iTerm 2
mv ~/Library/Preferences/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.backup.plist
ln -s "$XDG_CONFIG_HOME"/iterm2/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist

echo 'All of the symlinks created!'
