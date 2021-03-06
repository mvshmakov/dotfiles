# Path to your oh-my-zsh installation.
export ZSH="/Users/$USER/.oh-my-zsh"
# How often to auto-update ZSH (in days).
export UPDATE_ZSH_DAYS=7

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    git-flow
    autopep8
    brew
    colorize
    colored-man-pages
    common-aliases
    django
    docker
    docker-compose
    heroku
    history
    last-working-dir
    node
    npm
    nvm
    osx
    pep8
    pip
    python
    rsync
    tmux
    vscode
    zsh-autosuggestions
    zsh-output-highlighting
)

source ~/.oh-my-zsh/oh-my-zsh.sh

source ~/.oh-my-zsh/custom/plugins/.iterm2_shell_integration.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

source ~/shell-sources/.aliases
source ~/shell-sources/.exports
source ~/shell-sources/.functions

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

ssh-add ~/.ssh/id_rsa

# GRC colorizes nifty unix tools all over the place
if (( $+commands[grc] )) && (( $+commands[brew] ))
then
    source `brew --prefix`/etc/grc.bashrc
fi

eval "$(pyenv init -)"
