# Dotfile symlinks - the stow replacement.
#
# Every top-level directory of the repository is a "package" whose tree
# mirrors $HOME (the GNU stow layout this repo has always used):
#   zsh/.config/zsh/...   ->  ~/.config/zsh   (whole directory)
#   home/.bashrc          ->  ~/.bashrc
#   home/.ssh/config      ->  ~/.ssh/config   (file: ~/.ssh is shared)
# Directories that other software owns as well (`shared` below) are
# descended into and their children linked - stow's "folding" boundary, made
# explicit. Everything else is linked as a whole directory, so files created
# at runtime inside them (zsh compdumps, launchd plists) land in the repo,
# exactly as before, and are covered by .gitignore.
#
# Links are out-of-store symlinks to the live checkout: editing a config
# takes effect immediately, no rebuild. home-manager creates, updates and
# removes them on `darwin-rebuild switch`.
{ config, lib, ... }:
let
  # Absolute path of the working copy (mkOutOfStoreSymlink needs it)
  checkout = "${config.home.homeDirectory}/projects/personal/dotfiles";

  # The tracked tree, used only to discover what to link
  root = ../../../../..;

  # Never linked (the old .stow-global-ignore plus repo files)
  ignoredEntries = [
    ".DS_Store"
    "README.md"
    "LICENSE"
  ];
  # The old home/.stow-local-ignore: not dotfiles, they just live in home/
  homeIgnored = [
    ".vscode"
    "macos"
    "scripts"
  ];
  # Directories that exist in $HOME independently of this repo: descend.
  # ~/.local/bin is deliberately NOT here: it is linked whole, as stow did,
  # so the submodule (yubitouch) and the git-ignored uv shims inside it work
  shared = [
    ".config"
    ".local"
    ".local/share"
    ".local/state"
    ".ssh"
    "Library"
    "Library/Preferences"
    "Library/Application Support"
  ];

  isPackage = name: type: type == "directory" && !lib.hasPrefix "." name;

  entriesOf =
    pkg: rel: dir:
    lib.filterAttrs (
      name: _: !lib.elem name ignoredEntries && !(pkg == "home" && rel == "" && lib.elem name homeIgnored)
    ) (builtins.readDir dir);

  # Walk one package; returns { "<target relative to $HOME>" = { source = ...; }; }
  walk =
    pkg: rel: dir:
    lib.concatMapAttrs (
      name: type:
      let
        rel' = if rel == "" then name else "${rel}/${name}";
      in
      if type == "directory" && lib.elem rel' shared then
        walk pkg rel' (dir + "/${name}")
      else
        {
          ${rel'}.source = config.lib.file.mkOutOfStoreSymlink "${checkout}/${pkg}/${rel'}";
        }
    ) (entriesOf pkg rel dir);

  packages = lib.filterAttrs isPackage (builtins.readDir root);
in
{
  home.file = lib.concatMapAttrs (pkg: _: walk pkg "" (root + "/${pkg}")) packages;
}
