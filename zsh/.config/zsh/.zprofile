# Manually setting up language environment for double-width characters
# https://sw.kovidgoyal.net/kitty/faq/#keys-such-as-arrow-keys-backspace-delete-home-end-etc-do-not-work-when-using-su-or-sudo
export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# XDG Base Directory specification
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
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

# `brew` is not yet available in the shell yet, so we have to use the full path
# This sets HOMEBREW_PREFIX, HOMEBREW_CELLAR, HOMEBREW_REPOSITORY and
# adds itself to the PATH, MANPATH and INFOPATH
# https://docs.brew.sh/Manpage#shellenv
eval "$(/opt/homebrew/bin/brew shellenv)"
# Make GNU coreutils available in the shell without a prefix
PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
# Use latest ncurses version for the most up-to-date terminfo tables
# Check which one is active with `infocmp -x tmux-256color`
PATH="$(brew --prefix ncurses)/bin:$PATH"

# Add pyenv executable to PATH and enable shims
# PYENV_ROOT is needed for XDG Base Directory compliance
# https://github.com/pyenv/pyenv#set-up-your-shell-environment-for-pyenv
export PYENV_ROOT="$XDG_DATA_HOME/.pyenv"
command -v pyenv >/dev/null || PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# https://github.com/Schniz/fnm#zsh
eval "$(fnm env --use-on-cd)"
# Only after fnm is added to PATH yarn will be available as binary
PATH="$(yarn global bin):$PATH"

# Export modified PATH to make it available to (sub)shell(s)
# Check path for validness with echo `"$PATH" | tr ':' '\n'`
export PATH

# Load brew-hosted ZSH completions. Should go before the compinit call.
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    export FPATH
fi

export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

# All env variables: https://docs.brew.sh/Manpage#environment
# Runs 'brew autoremove' (remove formulas installed as dependencies that are
# no longer needed) when one runs 'brew cleanup' and 'brew uninstall'
export HOMEBREW_AUTOREMOVE=1
# Uses `bat` on `brew cat`
export HOMEBREW_BAT=1
# Suppress the warning about controlling Homebrew with environment variables
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_VERBOSE=1
export HOMEBREW_BREWFILE="$XDG_CONFIG_HOME/brew/Brewfile"
# GitHub will allow a greater number of API requests with PAT
HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)"
export HOMEBREW_GITHUB_API_TOKEN

# Opt-out from analytics https://consoledonottrack.com/
export DO_NOT_TRACK=1
# Opting out only from Google Analytics https://brew.sh/2023/02/16/homebrew-4.0.0/
# Remove after 90 days completely
export HOMEBREW_NO_GOOGLE_ANALYTICS=1

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

# GPG is very hard to make work with XDG Base Directory spec
# Mainly due to GPG Tools not supporting it properly
# export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export LESSHISTFILE="$XDG_DATA_HOME/less/history"

export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"

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
export BROWSER="Velja.app"
export VIDEO="mpv"
# TODO: use "lucc/nvimpager" instead both
export PAGER="less"
export GIT_PAGER="delta"

export COLORTERM="truecolor"

# ZSH-related
# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh
# How often to auto-update ZSH (in days).
export UPDATE_ZSH_DAYS=7
# Needed for fzf plugin https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/fzf#fzf_base
FZF_BASE=$(brew --prefix fzf)
export FZF_BASE
export FZF_DEFAULT_COMMAND="rg --files --no-ignore-vcs --hidden"

# Use nvim in man pages https://muru.dev/2015/08/28/vim-for-man.html
export MANPAGER="col -b | nvim -c 'set ft=man nomod nolist ignorecase' -"

export SSH_KEY_PATH=~/.ssh/id_rsa
export SSH_TEST_KEY_PATH=~/.ssh/id_rsa-test
# Required for the ssh-askpass https://github.com/theseal/ssh-askpass/blob/master/ssh-askpass.plist#L14-L15
SSH_ASKPASS="$(brew --prefix theseal/ssh-askpass/ssh-askpass)/bin/ssh-askpass"
export SSH_ASKPASS
# Sudo prompt with be taken from SSH_ASKPASS
export SUDO_ASKPASS="$SSH_ASKPASS"

# Use bat as fzf preview tool
# TODO: preview does not work well for reverse-i-search
export FZF_DEFAULT_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
# Preview all themes:
# bat --list-themes | fzf --preview="bat --theme={} --color=always /path/to/file"
export BAT_THEME="Nord"
export HIGHLIGHT_STYLE=nord

# For pinentry-mac
# Faster than $(tty), source: https://github.com/romkatv/powerlevel10k#how-do-i-export-gpg_tty-when-using-instant-prompt
export GPG_TTY=$TTY
# Just for the convenience, e.g.
# gpg --edit-key $GPG_KEY
export GPG_KEY="88C371E66837B278"

# Make ~/.wgetrc, ~/.wget-hsts compliant with XDG Base Directory spec.
# Note: wget does not support env variables in wgetrc, so need to use an absolute path.
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
export PYTHONIOENCODING='UTF-8'
# Use a startup file for the interactive shell
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonstartup.py"

# To correctly link and build psycopg2: https://stackoverflow.com/a/69403177/12349023
LIBPQ_PREFIX="$(brew --prefix libpq)"
OPENSSL_PREFIX="$(brew --prefix openssl)"
export LDFLAGS="-L$LIBPQ_PREFIX/lib -L$OPENSSL_PREFIX/lib"
export CPPFLAGS="-I$LIBPQ_PREFIX/include -I$OPENSSL_PREFIX/include"
