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
HISTCONTROL='ignoreboth';
HISTFILE=~/.cache/bash/history

ssh-add ~/.ssh/id_rsa

set -o vi

# GRC colorizes nifty unix tools all over the place
if (( $+commands[grc] )) && (( $+commands[brew] ))
then
    source `brew --prefix`/etc/grc.bashrc
fi

eval "$(pyenv init -)"
eval $(thefuck --alias)

source ~/shell-sources/aliasrc
source ~/shell-sources/.functions

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Load pyenv into the shell by adding
# the following to ~/.zshrc:
eval "$(pyenv init -)"

# Activate *direnv* https://direnv.net/docs/hook.html#zsh
eval "$(direnv hook bash)"