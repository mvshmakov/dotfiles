# For coming from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH:$HOME/.cargo/bin
# Path customization
export PATH="/usr/local/sbin:$(brew --prefix coreutils)/libexec/gnubin:$PATH"
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

export INPUTRC=$XDG_CONFIG_HOME/readline/inputrc
export HOMEBREW_BREWFILE=$XDG_CONFIG_HOME/brew/Brewfile

# To move .zsh_sessions and friends out of the dotfiles repo
#
# These are used by Apple in /etc/zshrc, which is sourced _before_ .zshrc
# Wouldn't have to go in .zprofile otherwise.
# We could put them in .zshenv, but that file is best kept as small as possible.
# https://unix.stackexchange.com/questions/654663/problem-with-zsh-history-file
export SHELL_SESSION_DIR=$XDG_STATE_HOME/zsh/sessions
export SHELL_SESSION_FILE=$SHELL_SESSION_DIR/$TERM_SESSION_ID

export _Z_DATA=$XDG_DATA_HOME/z
export LESSHISTFILE=$XDG_DATA_HOME/less/history

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
export PAGER="less"
export GIT_PAGER="delta"

export COLORTERM="truecolor"

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

export SSH_KEY_PATH="~/.ssh/id_rsa"
export SSH_TEST_KEY_PATH="~/.ssh/id_rsa-test"

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
export PYTHONIOENCODING='UTF-8';

# Use bat as fzf preview tool
export FZF_DEFAULT_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
# Preview all themes:
# bat --list-themes | fzf --preview="bat --theme={} --color=always /path/to/file"
export BAT_THEME="Nord"
export HIGHLIGHT_STYLE=nord

# Add pyenv executable to PATH and
# enable shims by adding the following
# to ~/.profile and ~/.zprofile:
export PYENV_ROOT="$XDG_DATA_HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
