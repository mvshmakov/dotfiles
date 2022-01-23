# Run to measure startup time:
# https://blog.askesis.pl/post/2017/04/how-to-debug-zsh-startup-time.html
# time  zsh -i -c exit
# Injects profiling code for zsh
# zmodload zsh/zprof

# TODO: Speed up zsh compinit by only checking cache once a day.
# https://gist.github.com/ctechols/ca1035271ad134841284
autoload -Uz compinit
if [[ -n $XDG_CACHE_HOME/zsh/zcompdump-$USER-$ZSH_VERSION(#qN.mh+24) ]]; then
  compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
else
  compinit -C -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
fi

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Increase ZSH history size. Allow 1 000 000 entries; the default is 500.
HISTSIZE=1000000
SAVEHIST=10000000
HISTFILESIZE=1000000000
HISTFILE=$XDG_DATA_HOME/zsh/history

# Ensures that commands are added to the history immediately.
# Otherwise, the history appended only when the shell exits and it could be lost.
# setopt INC_APPEND_HISTORY
# setopt EXTENDED_HISTORY         # record timestamp of command in HISTFILE
# setopt SHARE_HISTORY            # share command history data

# setopt HIST_IGNORE_SPACE        # ignore commands that start with space
# setopt HIST_IGNORE_ALL_DUPS     # Complete command duplicates are not added to the history
# setopt HIST_FIND_NO_DUPS        # Ctrl + R will ignore dups durng a search
# setopt HIST_EXPIRE_DUPS_FIRST   # delete duplicates first when HISTFILE size exceeds HISTSIZE
# setopt HIST_VERIFY              # show command with history expansion to user before running it

# cd works as pushd
# setopt auto_pushd
# setopt pushd_ignore_dups
# setopt pushdminus

# Allow to type bash-like comments in the shells
# setopt interactivecomments

# source ~/.oh-my-zsh/custom/plugins/.iterm2_shell_integration.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
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
    # 
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
    # Jump to frecenct directories: https://github.com/rupa/z
    z
    # Adds autosuggestions like in Fish
    zsh-autosuggestions
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

# Syntax highlighting bundle
# Should be the last one https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md#antigen
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme
antigen theme robbyrussell

# Tell Antigen that you're done
antigen apply

# Be quiet on success
ssh-add -q ~/.ssh/id_rsa
ssh-add -q ~/.ssh/id_rsa-test

# GRC colorizes nifty unix tools all over the place
if (( $+commands[grc] )) && (( $+commands[brew] ))
then
    source `brew --prefix`/etc/grc.bashrc
fi

source ~/.oh-my-zsh/oh-my-zsh.sh

source ~/shell-sources/aliasrc
source ~/shell-sources/.functions

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Load pyenv into the shell by adding
# the following to ~/.zshrc:
eval "$(pyenv init -)"

# Activate *direnv* https://direnv.net/docs/hook.html#zsh
eval "$(direnv hook zsh)"

# https://github.com/Schniz/fnm#zsh
eval "$(fnm env)"

# For directory colors definition support in file.
# See https://www.gnu.org/software/coreutils/manual/html_node/dircolors-invocation.html#dircolors-invocation
eval "$(dircolors $XDG_CONFIG_HOME/dircolors/dir_colors)"

# Create a `main` session and load it by default to the shell
# https://unix.stackexchange.com/a/113768
if command -v tmux &> /dev/null &&
    [ -n "$PS1" ] &&
    # Uncomment to enable tmux init in more broad cases
    # [[ ! "$TERM" =~ screen ]] &&
    # [[ ! "$TERM" =~ tmux ]] &&
    # Uncomment to init tmux only on the kitty 
    [ "$TERM" = "xterm-kitty" ] &&
    [ -z "$TMUX" ]; then
  exec tmux new-session -A -s main
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
