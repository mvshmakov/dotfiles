#!/usr/bin/env zsh

# Colorizes common UNIX tools output (GRC - Generic Colorizer)
# [[ -s "$(brew --prefix)/etc/grc.zsh" ]] && source "$(brew --prefix)/etc/grc.zsh"

# Sets up and exports correct LS_COLORS to provide the highliting for different UNIX tools output (e.g., ls, tree, etc.)
# See https://www.gnu.org/software/coreutils/manual/html_node/dircolors-invocation.html#dircolors-invocation
# Also https://www.nordtheme.com/docs/ports/dircolors/installation
test -r "$XDG_CONFIG_HOME/dircolors/dir_colors" && eval $(dircolors "$XDG_CONFIG_HOME/dircolors/dir_colors")

# https://github.com/romkatv/powerlevel10k#how-do-i-initialize-direnv-when-using-instant-prompt
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# After the initialization, it is impossible to enable GRC.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Run to measure startup time:
# https://blog.askesis.pl/post/2017/04/how-to-debug-zsh-startup-time.html
# time  zsh -i -c exit
# Injects profiling code for zsh
# zmodload zsh/zprof

# Load brew-hosted ZSH completions. Should go before the compinit call.
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
if type brew &>/dev/null
then
  export FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# TODO: speed up zsh compinit by only checking cache once a day.
# TODO: check if this even works
# https://gist.github.com/ctechols/ca1035271ad134841284
autoload -Uz compinit
# Enable hidden files completion
if [[ -n "$XDG_CACHE_HOME/zsh/zcompdump-$USER-$ZSH_VERSION(#qN.mh+24)" ]]; then
  compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
else
  compinit -C -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
fi

eval "$(bw completion --shell zsh); compdef _bw bw;"
_comp_options+=(globdots)

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
setopt EXTENDED_HISTORY # record timestamp of command in HISTFILE
setopt SHARE_HISTORY    # share command history data

setopt HIST_IGNORE_SPACE      # ignore commands that start with space
setopt HIST_IGNORE_ALL_DUPS   # Complete command duplicates are not added to the history
setopt HIST_FIND_NO_DUPS      # Ctrl + R will ignore dups durng a search
setopt HIST_EXPIRE_DUPS_FIRST # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_VERIFY            # show command with history expansion to user before running it

# Makes cd work as pushd
setopt auto_pushd
setopt pushd_ignore_dups
# Exchanges the meanings of '+'' and '-' when used with a number to specify a directory in the stack.
setopt pushdminus

# Allow to type bash-like comments in the shells
# setopt interactivecomments

# source ~/.oh-my-zsh/custom/plugins/.iterm2_shell_integration.zsh
# source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# source ~/.oh-my-zsh/custom/plugins/zsh-output-highlighting/zsh-output-highlighting.zsh
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
  history-substring-search
  # Enables fzf's fuzzy auto-completion and key bindings
  fzf
  # Keeps track of the last used working directory and automatically jumps into it for new shells
  last-working-dir
  # Completion as well as adding many useful aliases
  npm
  pip
  ripgrep
  # Prefixes the previous command with sudo on double ESC
  sudo
  # Autocompletion
  yarn
  # Adds autosuggestions like in Fish
  # zsh-autosuggestions
  # Highlights stuff
  # zsh-output-highlighting
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
# Speeds up original https://github.com/rupa/z tool
antigen bundle agkozak/zsh-z

antigen bundle zsh-users/zsh-autosuggestions
# Syntax highlighting bundle
# Should be the last one https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md#antigen
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme
# antigen theme spaceship-prompt/spaceship-prompt  # too slow
antigen theme romkatv/powerlevel10k
# antigen theme agnoster                           # not the best customizability

# Tell Antigen that you're done
antigen apply

# Be quiet on success
eval "$(ssh-add -q --apple-use-keychain $SSH_KEY_PATH)"
eval "$(ssh-add -q --apple-use-keychain $SSH_TEST_KEY_PATH)"

source ~/shell-sources/aliasrc
source ~/shell-sources/.functions

# TODO: enable vi mode, but need to check if the plugin needed like https://github.com/softmoth/zsh-vim-mode
# bindkey -v

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

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

# Load pyenv into the shell by adding
# the following to ~/.zshrc:
eval "$(pyenv init -)"

# Create a `main` session and load it by default to the shell
# https://unix.stackexchange.com/a/113768
# if command -v tmux &>/dev/null &&
#   [ -n "$PS1" ] &&
#   # Uncomment to enable tmux init in more broad cases
#   # [[ ! "$TERM" =~ screen ]] &&
#   # [[ ! "$TERM" =~ tmux ]] &&
#   # Init tmux only in kitty
#   [ "$TERM" = "xterm-kitty" ] &&
#   [ -z "$TMUX" ]; then
#   exec tmux new-session -A -s main
# fi

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# Auto-inserted by $(brew --prefix)/opt/fzf/install
# Can be uninstalled with uninstall script
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Activate *direnv* https://direnv.net/docs/hook.html#zsh
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"
