#!/usr/bin/env zsh
#
# Main ZSH config file
# TODO: go through `man zsh` documentation and enable interesting options

# Run to measure startup time:
# https://blog.askesis.pl/post/2017/04/how-to-debug-zsh-startup-time.html
# time  zsh -i -c exit
# Injects profiling code for zsh
# zmodload zsh/zprof

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

autoload -Uz compinit
# Fancy cd using frecency, agkozak/zsh-z (rupa/z) alternative
# Should be added after autoload compinit, but before the compinit call
eval "$(zoxide init zsh)"
# Store the .zcompdump and friends in the cache home directory
compinit -C -d $XDG_CACHE_HOME/zsh/.zcompdump

# Load pyenv into the shell by adding
# the following to ~/.zshrc:
eval "$(pyenv init -)"

# https://github.com/romkatv/powerlevel10k#how-do-i-initialize-direnv-when-using-instant-prompt
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

# Setup alias convenience commands for github-copilot-cli
# https://www.npmjs.com/package/@githubnext/github-copilot-cli#user-content-setup-alias-convenience-commands
eval "$(gh copilot alias -- zsh)"

# Colorizes common UNIX tools output (GRC - Generic Colorizer)
# GRC_BINARY="$(brew --prefix)/etc/grc.zsh"
# [[ -f "$GRC_BINARY" ]] && source "$GRC_BINARY"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"

# Increase ZSH history size. Allow 1 000 000 entries; the default is 500.
# Exporting for the $XDG_CONFIG_HOME/python/pythonstartup.py
export HISTSIZE=1000000
SAVEHIST=10000000
HISTFILESIZE=1000000000
HISTFILE="$XDG_DATA_HOME/zsh/history"

# Omit duplicates and commands that begin with a space from history.
HISTCONTROL="ignoreboth"

# Ensures that commands are added to the history immediately.
# Otherwise, the history appended only when the shell exits and it could be lost.
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY       # record timestamp of command in HISTFILE
setopt SHARE_HISTORY          # share command history data
setopt HIST_IGNORE_SPACE      # ignore commands that start with space
setopt HIST_IGNORE_ALL_DUPS   # Complete command duplicates are not added to the history
setopt HIST_FIND_NO_DUPS      # Ctrl + R will ignore dups durng a search
setopt HIST_EXPIRE_DUPS_FIRST # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_VERIFY            # show command with history expansion to user before running it

setopt GLOB_COMPLETE          # Trigger the completion after a glob * instead of expanding it.
setopt MENU_COMPLETE          # Automatically highlight first element of completion menu
setopt COMPLETE_IN_WORD       # Complete from both ends of a word.
setopt AUTO_LIST              # Automatically list choices on ambiguous completion.
setopt LIST_PACKED            # Completion menu will take less space
setopt LIST_ROWS_FIRST        # Matches are sorted in rows instead of columns.
setopt GLOBDOTS               # Lists hidden files during the completion: https://unix.stackexchange.com/a/366137

# setopt COMPLETE_ALIASES     # TODO: setting this disables zsh-z completion: https://github.com/agkozak/zsh-z#complete_aliases

setopt AUTO_PUSHD             # Makes cd work as pushd
setopt PUSHD_IGNORE_DUPS
setopt PUSHDMINUS             # Exchanges the meanings of '+'' and '-' when used with a number to specify a directory in the stack.
setopt AUTO_CD                # Allows to cd into a directory even without an explicit `cd` command, e.g.: ../directory

unsetopt LIST_BEEP            # So that ZSH will not beep on each completion, only on errors

# Will try all of the suggestion types starting from the first
ZSH_AUTOSUGGEST_STRATEGY=(history completion match_prev_cmd)

# source $(brew --prefix)/share/antigen/antigen.zsh
# antigen init $XDG_CONFIG_HOME/zsh/.antigenrc
export ZPLUG_HOME=/opt/homebrew/opt/zplug
source $ZPLUG_HOME/init.zsh
source $XDG_CONFIG_HOME/zsh/.zplugrc

# Needed to make command-not-found plugin work
source "$(brew --repository)/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"

source ~/shell-sources/aliasrc
source ~/shell-sources/zsh-aliasrc
source ~/shell-sources/.functions

# Enable vi keymap mode
bindkey -v

# The following block of bindings enables the support of
# zsh-history-substring-search in vi, emacs and UP/DOWN ways
# https://github.com/zsh-users/zsh-history-substring-search#usage
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
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

# Be quiet on success
eval "$(ssh-add -q --apple-use-keychain $SSH_KEY_PATH)"
if [[ -n "$SSH_TEST_KEY_PATH" ]]; then
  eval "$(ssh-add -q --apple-use-keychain $SSH_TEST_KEY_PATH)"
fi

# Sets up and exports correct LS_COLORS to provide the highliting for different UNIX tools output (e.g., ls, tree, etc.)
# See https://www.gnu.org/software/coreutils/manual/html_node/dircolors-invocation.html#dircolors-invocation
# Also https://www.nordtheme.com/docs/ports/dircolors/installation
test -r "$XDG_CONFIG_HOME/dircolors/dir_colors" && eval $(dircolors "$XDG_CONFIG_HOME/dircolors/dir_colors")

# Create a `main` session and load it by default to the shell
# https://unix.stackexchange.com/a/113768
if command -v tmux &>/dev/null && [ -n "$PS1" ] && [ -z "$TMUX" ] &&
  { 
    # Uncomment to enable tmux init in more broad cases
    [[ "$TERM_PROGRAM" = "iTerm.app" ]] ||
    [[ "$TERM_PROGRAM" = "ghostty" ]];
  }; then
  exec tmux new-session -A -s main
fi

# Auto-inserted by $(brew --prefix)/opt/fzf/install
# Can be uninstalled with uninstall script
source ~/.fzf.zsh

eval "$(starship init zsh)"

# bun completions
[ -s "/Users/mvshmakov/.bun/_bun" ] && source "/Users/mvshmakov/.bun/_bun"
# npm completions
eval "$(npm completion)"
