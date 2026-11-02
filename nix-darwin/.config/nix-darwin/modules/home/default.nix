# home-manager: user packages + the dotfile symlinks (./dotfiles.nix).
#
# The dotfiles (zsh, git, nvim, tmux, ...) stay plain files in this repo,
# linked into $HOME as out-of-store symlinks, so they are edited in place
# without a rebuild. Do NOT enable `programs.<tool>` modules that write into
# ~/.config for tools whose directory is linked that way - home-manager would
# back up / replace files inside the repository's working tree.
{ inputs, username, ... }:
{
  imports = [
    ./packages.nix
    ./dotfiles.nix
    inputs.nix-index-database.homeModules.nix-index
  ];

  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
    # Used for backwards compatibility, read the release notes before
    # changing: https://nix-community.github.io/home-manager/release-notes.xhtml
    stateVersion = "26.05";
  };

  # `home-manager` CLI for `home-manager news`/`generations`
  programs.home-manager.enable = true;

  # `, <cmd>` runs a program without installing it (uses the pre-built
  # nix-index database from the flake input); shell hooks are not written
  # because no programs.zsh/bash module is enabled here
  programs.nix-index-database.comma.enable = true;
}
