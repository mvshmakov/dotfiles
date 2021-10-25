# Run to measure startup time:
# https://blog.askesis.pl/post/2017/04/how-to-debug-zsh-startup-time.html
# time  zsh -i -c exit
# Injects profiling code for zsh
# zmodload zsh/zprof

# TODO: Speed up zsh compinit by only checking cache once a day.
# https://gist.github.com/ctechols/ca1035271ad134841284
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

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
HISTFILE=~/.cache/zsh/history

source ~/.oh-my-zsh/custom/plugins/.iterm2_shell_integration.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-output-highlighting/zsh-output-highlighting.zsh
# source ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

plugins=(
    # Provides common aliases e.g for ls and cp
    common-aliases
    # Copies the directory name/file content
    copydir
    copyfile
    # Auto-completion for docker
    docker
    # Unpacks passed archive
    extract
    # Some git aliases
    git
    # 
    history-substring-search
    # Enables fzf's fuzzy auto-completion and key bindings
    fzf
    # Keeps track of the last used working directory and automatically jumps into it for new shells
    last-working-dir
    # Completion as well as adding many useful aliases
    npm
    # Autocompletions
    nvm
    pip
    ripgrep
    # Prefixes the previous command with sudo on double ESC
    sudo
    # Fixes commands for us
    thefuck
    # Autocompletion
    yarn
    # Adds autosuggestions like in Fish
    zsh-autosuggestions
    # Highlights stuff
    zsh-output-highlighting
)

source $(brew --prefix)/share/antigen/antigen.zsh

# TODO: .antigenrc
# Load the oh-my-zsh's library
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh)
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found

# Syntax highlighting bundle
# Should be the last one https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md#antigen
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme
antigen theme robbyrussell

# Tell Antigen that you're done
antigen apply

ssh-add ~/.ssh/id_rsa

set -o vi

# GRC colorizes nifty unix tools all over the place
if (( $+commands[grc] )) && (( $+commands[brew] ))
then
    source `brew --prefix`/etc/grc.bashrc
fi

eval "$(pyenv init -)"
eval $(thefuck --alias)

source ~/.oh-my-zsh/oh-my-zsh.sh

source ~/shell-sources/aliasrc
source ~/shell-sources/.functions

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Load pyenv into the shell by adding
# the following to ~/.zshrc:
eval "$(pyenv init -)"

# Activate *direnv* https://direnv.net/docs/hook.html#zsh
eval "$(direnv hook zsh)"
