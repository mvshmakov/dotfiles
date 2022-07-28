# Manually setting up language environment for double-width characters
# https://sw.kovidgoyal.net/kitty/faq/#keys-such-as-arrow-keys-backspace-delete-home-end-etc-do-not-work-when-using-su-or-sudo
export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
# Non-standard XDG env variable name, but recommended location
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
# https://github.com/rust-lang/cargo/issues/1734#issuecomment-665247169
export XDG_BIN_HOME="$HOME/.local/bin"

# pip install --user, also cargo installs user binaries there, see
# https://github.com/rust-lang/cargo/issues/1734#issuecomment-163936588
export PATH="$XDG_BIN_HOME:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$(brew --prefix)/sbin:$(brew --prefix coreutils)/libexec/gnubin:$PATH"
# Use latest ncurses version for the most up-to-date terminfo tables
# It is possible to check which one is active with `infocmp -x tmux-256color`
export PATH="$(brew --prefix ncurses)/bin:$PATH"

export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export HOMEBREW_BREWFILE="$XDG_CONFIG_HOME/brew/Brewfile"

# Configuring Homebrew shell completions.
# This must be done before compinit is called.
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
export FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# Opt-out from analytics https://consoledonottrack.com/
export DO_NOT_TRACK=1
export HOMEBREW_NO_ANALYTICS=1

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

# Resetting base directories to comply with XDG Base Directory spec
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
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
# Use nvim for man pager https://muru.dev/2015/08/28/vim-for-man.html
export MANPAGER="col -b | nvim -c 'set ft=man nomod nolist ignorecase' -"

export SSH_KEY_PATH=~/.ssh/id_rsa
export SSH_TEST_KEY_PATH=~/.ssh/id_rsa-test
# Required for the ssh-askpass https://github.com/theseal/ssh-askpass/blob/master/ssh-askpass.plist#L14-L15
export SSH_ASKPASS="$(brew --prefix theseal/ssh-askpass/ssh-askpass)/bin/ssh-askpass"
# Sudo prompt with be taken from SSH_ASKPASS
export SUDO_ASKPASS="$SSH_ASKPASS"

# Use bat as fzf preview tool
# TODO: does not work well for reverse-i-search
export FZF_DEFAULT_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
# Preview all themes:
# bat --list-themes | fzf --preview="bat --theme={} --color=always /path/to/file"
export BAT_THEME="Nord"
export HIGHLIGHT_STYLE=nord

# For pinentry-mac
export GPG_TTY=$(tty)
# Just for the convenience, e.g.
# gpg --edit-key $GPGKEY
export GPGKEY="88C371E66837B278"


# Make ~/.wgetrc, ~/.wget-hsts compliant with XDG Base Directory spec.
# Note: wget does not support env variables in wgetrc, so need to use an absolute path.
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
export PYTHONIOENCODING='UTF-8'
# Use a startup file for the interactive shell
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonstartup.py"

# To correctly link and build psycopg2: https://stackoverflow.com/a/69403177/12349023
export LDFLAGS="-L$(brew --prefix libpq)/lib -L$(brew --prefix openssl)/lib"
export CPPFLAGS="-I$(brew --prefix libpq)/include -I$(brew --prefix openssl)/include"

# Add pyenv executable to PATH and
# enable shims by adding the following
# to ~/.profile and ~/.zprofile:
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export PATH="$PATH:$PYENV_ROOT/bin"
eval "$(pyenv init --path)"

# https://github.com/Schniz/fnm#zsh
eval "$(fnm env --use-on-cd)"
# Only now yarn will be available as binary in PATH
export PATH="$PATH:$(yarn global bin)"
