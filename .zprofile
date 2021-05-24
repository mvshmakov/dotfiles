# For coming from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH:$HOME/.cargo/bin
# Path customization
export PATH="/usr/local/sbin:$(brew --prefix coreutils)/libexec/gnubin:$PATH"
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  # Remote editor
  export EDITOR='vim'
  export VISUAL="vim"
else
  # Local editor
  export EDITOR='nvim'
  export VISUAL="nvim"
fi

export READER="zathura"
export BROWSER="brave"
export VIDEO="mpv"
export COLORTERM="truecolor"
export PAGER="less"
export GIT_PAGER="delta"

# ZSH-related
# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh
# How often to auto-update ZSH (in days).
export UPDATE_ZSH_DAYS=7
# Needed for fzf plugin https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/fzf#fzf_base
export FZF_BASE=$(brew --prefix fzf)
export FZF_DEFAULT_COMMAND="rg --files --no-ignore-vcs --hidden"

export MANPATH="/usr/local/man:$MANPATH"
# Using bat as a colorizing pager for man
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Set base path for the `cd`command (searches in home if nothing found in pwd)
export CDPATH=~/:~/projects:~/Yandex.Disk
export SSH_KEY_PATH="~/.ssh/id_rsa"

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
export PYTHONIOENCODING='UTF-8';

export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Use bat as fzf preview tool
export FZF_DEFAULT_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
export BAT_THEME="Monokai Extended"

# https://stackoverflow.com/questions/55839111/installing-psycopg2-fails-on-macos-with-unclear-error-message
export LDFLAGS="-L/usr/local/opt/openssl/lib"
