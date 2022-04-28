export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
# Non-standard env variable name, but recommended location
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
# https://github.com/rust-lang/cargo/issues/1734#issuecomment-665247169
export XDG_BIN_HOME="$HOME/.local/bin"

# pip install --user, also cargo installs user binaries there, see
# https://github.com/rust-lang/cargo/issues/1734#issuecomment-163936588
export PATH="$XDG_BIN_HOME:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$(brew --prefix)/sbin:$(brew --prefix coreutils)/libexec/gnubin:$PATH"

export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export HOMEBREW_BREWFILE="$XDG_CONFIG_HOME/brew/Brewfile"

# Opt-out from analytics https://consoledonottrack.com/
export DO_NOT_TRACK=1

# To move .zsh_sessions and friends out of the dotfiles repo
#
# These are used by Apple in /etc/zshrc, which is sourced _before_ .zshrc
# Wouldn't have to go in .zprofile otherwise.
# We could put them in .zshenv, but that file is best kept as small as possible.
# https://unix.stackexchange.com/questions/654663/problem-with-zsh-history-file
export SHELL_SESSION_DIR="$XDG_STATE_HOME/zsh/sessions"
export SHELL_SESSION_FILE="$SHELL_SESSION_DIR/$TERM_SESSION_ID"

# Is needed for bash's rupa/z package
# https://github.com/agkozak/zsh-z/issues/20#issuecomment-743363567
export _Z_DATA="$XDG_DATA_HOME/z"
# Is needed for zsh's agkozak/zsh-z alternative
export ZSHZ_DATA="$XDG_DATA_HOME/z"

# Manually setting up language environment
export LANG=en_US.UTF-8
export LESSHISTFILE="$XDG_DATA_HOME/less/history"

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
export BROWSER="Brave.app"
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
export PYTHONIOENCODING='UTF-8'
# To correctly link and build psycopg2: https://stackoverflow.com/a/69403177/12349023
export LDFLAGS="-L$(brew --prefix libpq)/lib -L$(brew --prefix openssl)/lib"
export CPPFLAGS="-I$(brew --prefix libpq)/include -I$(brew --prefix openssl)/include"

# Use bat as fzf preview tool
# TODO: does not work well for reverse-i-search
export FZF_DEFAULT_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
# Preview all themes:
# bat --list-themes | fzf --preview="bat --theme={} --color=always /path/to/file"
export BAT_THEME="Nord"
export HIGHLIGHT_STYLE=nord

# For pinentry-mac
GPG_TTY=$(tty)
export GPG_TTY

# Add pyenv executable to PATH and
# enable shims by adding the following
# to ~/.profile and ~/.zprofile:
export PYENV_ROOT="$XDG_DATA_HOME/.pyenv"
export PATH="$PATH:$PYENV_ROOT/bin"
eval "$(pyenv init --path)"
