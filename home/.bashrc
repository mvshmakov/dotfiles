# TODO: unify it with .zshrc
# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Increase Bash history size. Allow 1 000 000 entries; the default is 500.
HISTSIZE=1000000
SAVEHIST=10000000
HISTFILESIZE=1000000000
# Omit duplicates and commands that begin with a space from history.
HISTCONTROL="ignoreboth"
HISTFILE="$XDG_DATA_HOME/bash/history"

# Be quiet on success
ssh-add -q ~/.ssh/id_rsa
ssh-add -q ~/.ssh/id_rsa-test

# Colorizes common UNIX tools output (GRC - Generic Colorizer)
GRC_ALIASES=true
[[ -s "$(brew --prefix grc)" ]] && source "$(brew --prefix grc)"

source ~/shell-sources/aliasrc
source ~/shell-sources/.functions

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

# Load pyenv into the shell
eval "$(pyenv init -)"

# Activate *direnv* https://direnv.net/docs/hook.html#zsh
eval "$(direnv hook bash)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

source "$(brew --prefix)/etc/profile.d/z.sh"

# Configuring Homebrew shell completions
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-bash
if type brew &>/dev/null; then
    HOMEBREW_PREFIX="$(brew --prefix)"
    if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
        source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
    else
        for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
            [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
        done
    fi
fi
