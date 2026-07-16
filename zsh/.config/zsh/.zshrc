#!/usr/bin/env zsh
#
# Main ZSH config file
# TODO: go through `man zsh` documentation and enable interesting options
# TODO: split login, non-login and interactive shells: https://ghostty.org/docs/help/macos-login-shells#why-login-shells

# Run to measure startup time:
# https://blog.askesis.pl/post/2017/04/how-to-debug-zsh-startup-time.html
# time  zsh -i -c exit

# Create a `main` tmux session and load it by default to the shell
# Initializing this sooner helps startup time
# https://unix.stackexchange.com/a/113768
if command -v tmux &>/dev/null && [ -n "$PS1" ] && [ -z "$TMUX" ] &&
  { 
    # Uncomment to enable tmux init in more broad cases
    [[ "$TERM_PROGRAM" = "iTerm.app" ]] ||
    [[ "$TERM_PROGRAM" = "ghostty" ]] ||
    [[ "$TERM" = "alacritty" ]] ||
    [[ "$TERM" = "xterm-kitty" ]];
  }; then
  exec tmux new-session -A -s main
fi

# Injects profiling code for zsh
# zmodload zsh/zprof

# Some sandboxed shells don't provide XDG_CACHE_HOME.
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export ZIM_HOME=$XDG_CACHE_HOME/zim
# Download zimfw plugin manager if missing
if [[ ! -e $ZIM_HOME/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o $ZIM_HOME/zimfw.zsh \
    https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Install missing modules, and update $ZIM_HOME/init.zsh if missing or outdated
if [[ ! $ZIM_HOME/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source $ZIM_HOME/zimfw.zsh init
fi

# Necessary at least for the `last-working-dir` plugin from omz
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Increase ZSH history size. Allow 1 000 000 entries; the default is 500.
# Exporting for e.g., atuin (https://docs.atuin.sh/reference/import/#atuin-import)
# and $XDG_CONFIG_HOME/python/pythonstartup.py
# (bash counterparts like HISTFILESIZE/HISTCONTROL live in .bashrc; zsh
# ignores them, space-prefixed commands are handled by HIST_IGNORE_SPACE)
#
# Kept above the early returns below so that no shell ever exits with the
# in-repo default HISTFILE that Apple's /etc/zshrc sets from ZDOTDIR
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
# Default XDG_DATA_HOME like XDG_CACHE_HOME above: it is exported in
# .zprofile, which non-login shells never source
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"

# Initialize Homebrew early so tools in /opt/homebrew/bin are available.
# Skip when already initialized (login shells run brew shellenv in .zprofile);
# only non-login interactive shells, which skip .zprofile, need it here.
if [[ -x /opt/homebrew/bin/brew && -z "$HOMEBREW_PREFIX" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
# Must come after brew shellenv so asdf shims take precedence over /opt/homebrew/bin
PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# GitHub allows a greater number of API requests with a PAT, but resolving it
# eagerly costs ~120ms per shell (`gh auth token`), so inject it on the first
# brew call of the session instead
brew() {
  if [[ -z "$HOMEBREW_GITHUB_API_TOKEN" ]] && (( ${+commands[gh]} )); then
    export HOMEBREW_GITHUB_API_TOKEN="$(command gh auth token 2>/dev/null)"
  fi
  command brew "$@"
}

# VS Code captures the environment for its extension host by running a
# login+interactive probe shell with VSCODE_RESOLVING_ENVIRONMENT=1. Only the
# env exports above matter to it (PATH etc.; a probe timeout leaves
# extensions with a bare PATH, e.g. the 1Password extension not finding the
# `op` CLI). Startup is fast enough now (~0.05s to this point), but keep the
# early return: the probe gains nothing from the interactive setup below, a
# cold cache rebuild (after update-all) is still slow, and _ssh_add_once
# could pop a GUI askpass prompt from a headless probe on first boot.
if [[ -n "$VSCODE_RESOLVING_ENVIRONMENT" ]]; then
  return
fi

# Keep the compdump cache (and its .zwc/.dat/tempfile siblings) out of
# ZDOTDIR, which lives inside the dotfiles repo; zim defaults to
# ${ZDOTDIR}/.zcompdump otherwise
mkdir -p "$ZSH_CACHE_DIR"
zstyle ':zim:completion' dumpfile "$ZSH_CACHE_DIR/zcompdump"

# Initialize modules, all the completions must be defined beforehand
source $ZIM_HOME/init.zsh

# Many tools generate their shell integration by spawning themselves on every
# startup, which is slow (npm completion ~300ms, heroku ~460ms, plus the
# zoxide/fzf/atuin/starship init scripts). Cache the generated script and only
# rebuild when the tool's binary is newer than the cache, so `update-all`
# refreshes it automatically. Absent tools degrade gracefully to an empty
# cache (no error). `rm $ZSH_CACHE_DIR/zcache-*.zsh` forces a rebuild.
# Completion calls must stay after zim's compinit so compdef is available.
_zcache() {
  local name=$1
  shift
  local cache="$ZSH_CACHE_DIR/zcache-$name.zsh" bin
  bin=$(command -v "$1" 2>/dev/null)
  if [[ ! -f $cache || (-n $bin && $bin -nt $cache) ]]; then
    "$@" >|"$cache" 2>/dev/null
  fi
  source "$cache"
}
_zcache npm npm completion
_zcache docker docker completion zsh
_zcache ngrok ngrok completion
_zcache heroku heroku autocomplete:script zsh

# Fancy cd using frecency, agkozak/zsh-z (rupa/z) alternative
_zcache zoxide zoxide init --cmd=cd zsh
# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Required to make Shift-Tab to work with menu select  (exposes required function)
zmodload zsh/complist

# Ztyle pattern (great source: https://thevaluable.dev/zsh-completion-guide-examples/)
# :completion:<function>:<completer>:<command>:<argument>:<tag>
#
# * completion - String acting as a namespace, to avoid pattern collisions with other scripts also using zstyle.
# * <function> - Apply the style to the completion of an external function or widget.
# * <completer> - Apply the style to a specific completer. We need to drop the underscore from the completer's name here.
# * <command> - Apply the style to a specific command, like cd, rm, or sed for example.
# * <argument> - Apply the style to the nth option or the nth argument. It's not available for many styles.
# * <tag> - Apply the style to a specific tag.

# Caching the completions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
# Select completions from the menu
zstyle ':completion:*' menu select
# Autocomplete options for cd instead of directory stack (from pushd)
zstyle ':completion:*' complete-options true
# Define the order of completers we want to use
zstyle ':completion:*' completer _extensions _complete _approximate
# Required to make the groups work: https://stackoverflow.com/a/40869479
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %d --%f'
zstyle ':completion:*' group-name ''
# TODO: fix this for the ls -l
# Colors for files and directories ((s.:.) splits colors into an array)
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' dirinfo-format '%f '$'\e[93m%i\e[0m'
# Acts as a `ls -al` when listing the files
zstyle ':completion:*' file-list all
# Make zsh know about hosts already accessed by SSH
# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/common-aliases/common-aliases.plugin.zsh#L89-L90
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# The two-step direnv export + p10k instant-prompt dance was removed together
# with powerlevel10k (starship is the prompt now); a single hook is enough
(( ${+commands[direnv]} )) && eval "$(direnv hook zsh)"

# Colorizes common UNIX tools output (GRC - Generic Colorizer)
# GRC_BINARY="$HOMEBREW_PREFIX/etc/grc.zsh"
# [[ -f "$GRC_BINARY" ]] && source "$GRC_BINARY"

# Ensures that commands are added to the history immediately + recording the elapsed time correctly.
# Otherwise, the history appended only when the shell exits and it could be lost.
setopt INC_APPEND_HISTORY_TIME # INC_APPEND_HISTORY{_TIME} and SHARE_HISTORY are mutually exclusive 
# setopt SHARE_HISTORY           # share command history data - atuin takes care about it now
setopt EXTENDED_HISTORY        # record timestamp of command in HISTFILE
setopt HIST_IGNORE_SPACE       # ignore commands that start with space
# setopt HIST_IGNORE_ALL_DUPS  # Complete command duplicates are not added to the history - we want to have full history, dups are handled by atuin
setopt HIST_FIND_NO_DUPS       # Ctrl + R will ignore duplicates during a search
setopt HIST_EXPIRE_DUPS_FIRST  # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_VERIFY             # show command with history expansion to user before running it

setopt GLOB_COMPLETE           # Trigger the completion after a glob * instead of expanding it.
setopt MENU_COMPLETE           # Automatically highlight first element of completion menu
setopt COMPLETE_IN_WORD        # Complete from both ends of a word.
setopt AUTO_LIST               # Automatically list choices on ambiguous completion.
setopt LIST_PACKED             # Completion menu will take less space
setopt LIST_ROWS_FIRST         # Matches are sorted in rows instead of columns.
setopt GLOBDOTS                # Lists hidden files during the completion: https://unix.stackexchange.com/a/366137

# setopt COMPLETE_ALIASES     # TODO: setting this disables zsh-z completion: https://github.com/agkozak/zsh-z#complete_aliases

setopt AUTO_PUSHD              # Makes cd work as pushd
setopt PUSHD_IGNORE_DUPS
setopt PUSHDMINUS              # Exchanges the meanings of '+'' and '-' when used with a number to specify a directory in the stack.
setopt AUTO_CD                 # Allows to cd into a directory even without an explicit `cd` command, e.g.: ../directory

unsetopt LIST_BEEP             # So that ZSH will not beep on each completion, only on errors

# Will try all of the suggestion types starting from the first
export ZSH_AUTOSUGGEST_STRATEGY=(history completion match_prev_cmd)

# Needed to make command-not-found plugin work ($HOMEBREW_REPOSITORY is already
# exported by brew shellenv above, avoiding another brew subprocess)
[[ -n "$HOMEBREW_REPOSITORY" ]] && source "$HOMEBREW_REPOSITORY/Library/Homebrew/command-not-found/handler.sh"

source ~/shell-sources/aliasrc
source ~/shell-sources/zsh-aliasrc
source ~/shell-sources/.functions


####
# Key bindings
#
# ^X^V enables vim mode in ZSH, so no need to bindkey -v
####

# Enable vi keymap mode
bindkey -v

# To support built-in zsh functions documentation like bash does (e.g., `man bindkey`)
# By default, zsh aliases `run-help` to `man`, which does not have detailed descriptions.
# https://superuser.com/a/1563859/1916321
unalias run-help
autoload run-help
export HELPDIR="$HOMEBREW_PREFIX/share/zsh/help"
alias help=run-help

# Edit the current command line in $EDITOR
# Nice default from OMZ: https://github.com/ohmyzsh/ohmyzsh/blob/9650861e56a3404313adc35cbcb1f32a7015b99d/lib/key-bindings.zsh#L62-L65
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# The following block of bindings enables the support of
# zsh-history-substring-search in vi, emacs and UP/DOWN ways
# https://github.com/zsh-users/zsh-history-substring-search#usage
# bindkey "$terminfo[kcuu1]" history-substring-search-up
# bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# To enable alt+arrow keys navigation in zsh's ZLE (readline alternative)
# https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html
# https://apple.stackexchange.com/a/365225/444276
bindkey "\e\e[D" backward-word
bindkey "\e\e[C" forward-word
bindkey "^[[5D" beginning-of-line
bindkey "^[[5C" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[^N" newtab
bindkey "^?" backward-delete-char

# Enables Shift+Tab in autocomplete menu
bindkey -M menuselect '^[[Z' reverse-menu-complete

# Add SSH keys to the agent, but skip the slow --apple-use-keychain call
# (~320ms each) when the key is already loaded. macOS's launchd ssh-agent keeps
# keys across shells, so only the first shell after boot pays the cost; the
# fingerprint check (ssh-keygen + ssh-add -l) is ~20ms.
_ssh_add_once() {
  [[ -r $1 ]] || return
  local fp
  fp=$(ssh-keygen -lf "$1" 2>/dev/null | awk '{print $2}')
  if [[ -n $fp ]] && ssh-add -l 2>/dev/null | grep -q "$fp"; then
    return
  fi
  ssh-add -q --apple-use-keychain "$1"
}
_ssh_add_once "$SSH_KEY_PATH"
[[ -n "$SSH_TEST_KEY_PATH" ]] && _ssh_add_once "$SSH_TEST_KEY_PATH"

# The GNU dircolors-based LS_COLORS setup was removed together with coreutils
# (sticking to the macOS builtins): the nord dir_colors file had been parsing
# to an empty LS_COLORS anyway, and BSD ls colorizes via --color=auto natively.

_zcache fzf fzf --zsh

# Atuin needs to re-bind the `^R` after the `fzf` https://setup.atuin.sh/
# Disabling the up arrow as it is easy enough to filter with subsequent `^R`
_zcache atuin atuin init zsh --disable-up-arrow

# Config lives one level deep (stow package nests it), so point Starship at it explicitly
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
# --print-full-init emits the whole script (cacheable); the default two-stage
# bootstrap would re-spawn starship on every source, defeating the cache
_zcache starship starship init zsh --print-full-init
