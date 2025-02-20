#!/usr/bin/env bash
#
# TODO: unify it with .zshrc
# TODO: go through `man bash` documentation and enable interesting options

# Increase Bash history size. Allow 1 000 000 entries; the default is 500.
HISTSIZE=1000000
HISTFILESIZE=1000000000
# Omit duplicates and commands that begin with a space from history.
HISTCONTROL="ignoreboth"
HISTFILE="$XDG_DATA_HOME/bash/history"

eval "$(/opt/homebrew/bin/brew shellenv bash)"

# Be quiet on success
ssh-add -q --apple-use-keychain "$SSH_KEY_PATH"
ssh-add -q --apple-use-keychain "$SSH_TEST_KEY_PATH"

# Colorizes common UNIX tools output (GRC - Generic Colorizer)
export GRC_ALIASES=true
[[ -s "$(brew --prefix)/etc/grc.sh" ]] && source "$(brew --prefix)/etc/grc.sh"

source "$HOME"/shell-sources/aliasrc
source "$HOME"/shell-sources/.functions

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
if [ -e "$HOME/.ssh/config" ]; then
  complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh
fi

# Add tab completion for defaults read|write NSGlobalDomain
# You could just use -g instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# Initialize asdf
source "$(brew --prefix asdf)/libexec/asdf.sh"

# Initialize direnv
eval "$(asdf exec direnv hook bash)"

[ -f "$HOME"/.fzf.bash ] && source "$HOME"/.fzf.bash

source "$(brew --prefix)/etc/profile.d/z.sh"

# Configuring Homebrew shell completions
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-bash
if type brew &>/dev/null; then
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi



source /Users/mvshmakov/.config/broot/launcher/bash/br
