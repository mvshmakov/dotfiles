# yabai + skhd: intentionally NOT managed by nix-darwin's services.
#
# macOS grants Accessibility / Input Monitoring per binary (code signature
# or path). The nixpkgs builds are ad-hoc signed and live under a store path
# that changes with every update, so each `darwin-rebuild switch` that bumps
# them would silently break the window manager until the grants are redone
# by hand. The Homebrew bottles are stable, so both stay as brews
# (homebrew.nix) with the tracked plists in launchctl/Library/LaunchAgents.
#
# Flip `enable` here (and drop the two brews) only if that trade-off changes.
{ pkgs, ... }:
{
  services.yabai = {
    enable = false;
    package = pkgs.yabai;
    enableScriptingAddition = false;
  };

  services.skhd = {
    enable = false;
    package = pkgs.skhd;
  };
}
