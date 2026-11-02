# Login shells. nix-darwin generates /etc/zshrc, /etc/zshenv, /etc/zprofile
# and /etc/bashrc (backing the current ones up as *.before-nix-darwin) so
# that every shell gets the Nix profiles on PATH:
#   /run/current-system/sw/bin          (environment.systemPackages)
#   /etc/profiles/per-user/$USER/bin    (home-manager home.packages)
# The user's own config keeps living in ZDOTDIR (~/.config/zsh, stowed) and
# is sourced afterwards, so `brew shellenv` there still puts Homebrew first
# until the brew formulae are gone (phase 2 in README.md).
{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    # zim's `completion` module runs compinit with our zstyles; a second
    # global compinit in /etc/zshrc only costs startup time
    enableCompletion = false;
    enableGlobalCompInit = false;
    enableBashCompletion = false;
    # starship is the prompt, don't load the stock zsh prompt theme first
    promptInit = "";
    # nix-darwin hardcodes `setopt SHARE_HISTORY` in /etc/zshrc; .zshrc uses
    # INC_APPEND_HISTORY_TIME instead (mutually exclusive, atuin syncs
    # history across shells). HISTSIZE/SAVEHIST/HISTFILE are re-exported by
    # .zshrc anyway, exactly as with Apple's stock /etc/zshrc.
    interactiveShellInit = ''
      unsetopt SHARE_HISTORY
    '';
  };

  programs.bash = {
    enable = true;
    # .bashrc wires brew's bash-completion@2 itself
    completion.enable = false;
  };

  # Adds the Nix zsh/bash to /etc/shells (login shell stays /bin/zsh, which
  # shell.sh sets; switch with `chsh -s /run/current-system/sw/bin/zsh`)
  environment.shells = with pkgs; [
    zsh
    bash
  ];
}
