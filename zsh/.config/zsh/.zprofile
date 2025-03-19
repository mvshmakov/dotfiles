#!/usr/bin/env zsh
#
# Mostly setting the env variables here

# Manually setting up language environment for double-width characters
# https://sw.kovidgoyal.net/kitty/faq/#keys-such-as-arrow-keys-backspace-delete-home-end-etc-do-not-work-when-using-su-or-sudo
export LANG="en_US.UTF-8"
export LC_ALL="$LANG"
export LC_COLLATE="$LANG"
export LC_CTYPE="$LANG"
export LC_MESSAGES="$LANG"
export LC_MONETARY="$LANG"
export LC_NUMERIC="$LANG"
export LC_TIME="$LANG"

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
PATH="$XDG_BIN_HOME:$PATH"

# `brew` is not yet available in the shell yet, so we have to use the full path
# This sets HOMEBREW_PREFIX, HOMEBREW_CELLAR, HOMEBREW_REPOSITORY and
# adds itself to the PATH, MANPATH and INFOPATH
# https://docs.brew.sh/Manpage#shellenv
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
# Make GNU coreutils available in the shell without a prefix
PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
# Use latest ncurses version for the most up-to-date terminfo tables
# Check which one is active with `infocmp -x tmux-256color`
PATH="$(brew --prefix ncurses)/bin:$PATH"
# For Docker CLI tools to be accessible in the shell
# https://github.com/Homebrew/homebrew-cask/blob/bb82248bb7bfc6ff7fbc4b02dbb63f6f3aaead03/Casks/docker.rb#L118-L122
PATH="$HOME/.docker/bin:$PATH"

# Add pyenv executable to PATH and enable shims
# PYENV_ROOT is needed for XDG Base Directory compliance
# https://github.com/pyenv/pyenv#set-up-your-shell-environment-for-pyenv
export PYENV_ROOT="$XDG_DATA_HOME/.pyenv"
command -v pyenv >/dev/null || PATH="$PYENV_ROOT/bin:$PATH"

# Initialize direnv
source "$XDG_CONFIG_HOME"/asdf-direnv/zshrc
# Sets GOROOT: https://github.com/asdf-community/asdf-golang#goroot
source "$HOME"/.asdf/plugins/golang/set-env.zsh
# Check path for validness with echo `"$PATH" | tr ':' '\n'`
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# https://github.com/Schniz/fnm#zsh
# eval "$(fnm env --use-on-cd)"

# export NVM_DIR="$HOME/.nvm"
# [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
# [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Only after fnm/nvm/asdf is added to PATH yarn will be available as binary
# PATH="$(yarn global bin):$PATH"

# Load brew-hosted ZSH completions. Should go before the compinit call.
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
if type docker &>/dev/null; then
  FPATH="$HOME/.docker/completions:${FPATH}"
  export FPATH
fi

export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

# All env variables: https://docs.brew.sh/Manpage#environment
# Pass --greedy to cask upgrade command
# https://github.com/Homebrew/brew/issues/15097
export HOMEBREW_UPGRADE_GREEDY=1
# Uses `bat` on `brew cat`
export HOMEBREW_BAT=1
export HOMEBREW_VERBOSE=1
# Prints install times for each formula at the end of the run
export HOMEBREW_DISPLAY_INSTALL_TIMES=1
# Use Bootsnap to speed up repeated brew calls
export HOMEBREW_BOOTSNAP=1
# Always use a Homebrew-installed curl & git
export HOMEBREW_FORCE_BREWED_CURL=1
export HOMEBREW_FORCE_BREWED_GIT=1
# Forbid HTTPS to HTTP redirects
export HOMEBREW_NO_INSECURE_REDIRECT=1
# Use GUI when asking for a password (invoke `sudo -A`)
export SUDO_ASKPASS=1
export HOMEBREW_CASK_OPTS="--greedy"
export HOMEBREW_LOGS="$XDG_STATE_HOME/brew"
export HOMEBREW_CACHE="$XDG_CACHE_HOME/brew"
export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/brew/Brewfile"
# GitHub will allow a greater number of API requests with PAT
HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)"
export HOMEBREW_GITHUB_API_TOKEN

# Opt-out from analytics https://consoledonottrack.com/
export DO_NOT_TRACK=1
# Opt-out from motion animations https://docs.atuin.sh/configuration/config/#prefers_reduced_motion
export NO_MOTION=1

# To move .zsh_sessions and friends out of the dotfiles repo
#
# These are used by Apple in /etc/zshrc, which is sourced _before_ .zshrc
# Wouldn't have to go in .zprofile otherwise.
# We could put them in .zshenv, but that file is best kept as small as possible.
# https://unix.stackexchange.com/questions/654663/problem-with-zsh-history-file
export SHELL_SESSION_DIR="$XDG_STATE_HOME/zsh/sessions"
export SHELL_SESSION_FILE="$SHELL_SESSION_DIR/$TERM_SESSION_ID"

# Store the .zcompdump and friends in the cache home directory
# Variable is non-standard, but taken from the omz:
# https://github.com/ohmyzsh/ohmyzsh/blob/68f3ebb4de11aa2013ccc5252d4415840e0d7342/oh-my-zsh.sh#L144
export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

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
# TODO: a non-standard one, find the correct name
export IMG_VIEWER="viu"
export VIDEO="mpv"
# TODO: use "lucc/nvimpager" instead both
export PAGER="less"
export GIT_PAGER="delta"

# Needed for some programs to check if 24bit colors are supported by the terminal emulator
# https://marvinh.dev/blog/terminal-colors/
export COLORTERM="truecolor"
# Works only on MacOS/BSD - enables the CLI tools color by default
# https://unix.stackexchange.com/a/2904
export CLICOLOR=1

export BAT_THEME="Nord"
# For the `hightlight` CLI tool (syntax highlighting)
export HIGHLIGHT_STYLE=nord

# Needed for fzf plugin https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/fzf#fzf_base
export FZF_BASE=$(brew --prefix fzf)
export FZF_DEFAULT_COMMAND="rg --files --no-ignore-vcs --hidden"
# Using bat as the fzf preview tool + went through all the fzf customization options.
# Nord theme for the FZF (background is stripped for transparency, colors are corrected):
# https://github.com/junegunn/fzf/blob/master/ADVANCED.md#color-themes
export FZF_DEFAULT_OPTS='
--tmux
--height 40% --tmux bottom,40%
--preview "fzf-preview-extended {}"
--preview-window "wrap"
--style full
--border none
--no-scrollbar
--no-separator
--info inline
--cycle --ansi
--color=hl:#81A1C1,hl+:#81A1C1
--color=fg:#D8DEE9,fg+:#D8DEE9
--color=pointer:#81A1C1,marker:#81A1C1
--color=spinner:#81A1C1,header:#81A1C1
--color=info:#81A1C1,prompt:#81A1C1
'

# Use nvim in man pages https://muru.dev/2015/08/28/vim-for-man.html
export MANPAGER="col -b | nvim -c 'set ft=man nomod nolist ignorecase' -"

if [[ -f ~/.ssh/id_ed25519 ]]; then
  export SSH_KEY_PATH=~/.ssh/id_ed25519
elif [[ -f ~/.ssh/id_rsa ]]; then
  export SSH_KEY_PATH=~/.ssh/id_rsa
else 
  echo "No SSH key found in ~/.ssh, please generate one"
fi

if [[ -f ~/.ssh/id_ed25519-test ]]; then
  export SSH_TEST_KEY_PATH=~/.ssh/id_ed25519-test
elif [[ -f ~/.ssh/id_rsa-test ]]; then
  export SSH_TEST_KEY_PATH=~/.ssh/id_rsa-test
else
  unset SSH_TEST_KEY_PATH
fi

# Required for the ssh-askpass https://github.com/theseal/ssh-askpass/blob/master/ssh-askpass.plist#L14-L15
export SSH_ASKPASS="$(brew --prefix theseal/ssh-askpass/ssh-askpass)/bin/ssh-askpass"
# Sudo prompt will be taken from SSH_ASKPASS
export SUDO_ASKPASS="$SSH_ASKPASS"

# For pinentry-mac
# Faster than $(tty), source: https://github.com/romkatv/powerlevel10k#how-do-i-export-gpg_tty-when-using-instant-prompt
export GPG_TTY="$TTY"
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

export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/.npmrc"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node/history"

# To correctly link and build psycopg2: https://stackoverflow.com/a/69403177/12349023
LIBPQ_PREFIX="$(brew --prefix libpq)"
OPENSSL_PREFIX="$(brew --prefix openssl)"
# Also, add the HOMEBREW_PREFIX/(lib|include) to the LDFLAGS and CPPFLAGS
# https://docs.brew.sh/Homebrew-and-Python#brewed-python-modules
export LDFLAGS="-L$HOMEBREW_PREFIX/lib -L$LIBPQ_PREFIX/lib -L$OPENSSL_PREFIX/lib"
export CPPFLAGS="-I$HOMEBREW_PREFIX/include -I$LIBPQ_PREFIX/include -I$OPENSSL_PREFIX/include"
