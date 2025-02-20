#!/usr/bin/env bash
#
# TODO: unify it with .zshrc
# TODO: go through `man bash` documentation and enable interesting options

# Increase Bash history size. Allow 1 000 000 entries; the default is 500
# Exporting for e.g., atuin (https://docs.atuin.sh/reference/import/#atuin-import).
export HISTSIZE=1000000
export HISTFILESIZE=1000000000
export HISTFILE="$XDG_DATA_HOME/bash/history"
# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL="ignorespace"

eval "$(/opt/homebrew/bin/brew shellenv bash)"

# Be quiet on success
ssh-add -q --apple-use-keychain "$SSH_KEY_PATH"
if [[ -n "$SSH_TEST_KEY_PATH" ]]; then
  ssh-add -q --apple-use-keychain "$SSH_TEST_KEY_PATH"
fi

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

# Add pyenv executable to PATH and
# enable shims by adding the following
# to ~/.profile and ~/.zprofile:
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
PATH="$PATH:$PYENV_ROOT/bin"

export PATH
# Load pyenv into the shell
eval "$(pyenv init -)"

# Replaced with asdf
# https://github.com/Schniz/fnm#bash
# eval "$(fnm env --use-on-cd)"

# Activate *direnv* https://direnv.net/docs/hook.html#bash
eval "$(direnv hook bash)"

# Activate atuin https://setup.atuin.sh/
eval "$(atuin init bash)"

# Brew should have the binary in PATH already
eval "$(fzf --bash)"

eval "$(gh copilot alias -- zsh)"

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
