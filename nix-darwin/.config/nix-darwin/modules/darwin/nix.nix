# Nix itself + nixpkgs evaluation settings.
#
# The machine runs Determinate Nix (installed via Determinate.pkg), which
# manages /etc/nix/nix.conf, the nix-daemon launchd job, upgrades and garbage
# collection on its own. nix-darwin therefore must not touch any of that:
# the determinate module forces `nix.enable = false`, so `nix.settings`,
# `nix.gc`, `nix.optimise` and `nix.linux-builder` are unavailable here. Use
# `determinateNix.customSettings` (rendered to /etc/nix/nix.custom.conf)
# and `determinateNix.determinateNixd` instead.
{ inputs, username, ... }:
{
  imports = [ inputs.determinate.darwinModules.default ];

  determinateNix = {
    enable = true;

    # Mirrors what the installer wrote to /etc/nix/nix.custom.conf so the
    # daemon configuration does not change on the first switch, plus the
    # dev-shell friendly GC settings that used to live (ineffectively - they
    # are daemon-side settings) in ~/.config/nix/nix.conf
    customSettings = {
      extra-trusted-users = [ username ];
      # Keep dev-shell inputs and build-time dependencies out of GC so
      # `nix develop`/direnv shells are not rebuilt after every collection
      keep-outputs = true;
      keep-derivations = true;
    };
  };

  nixpkgs = {
    config.allowUnfree = false;
    overlays = import ../../overlays { inherit inputs; };
  };
}
