# Overlays applied to the stable package set
{ inputs }:
[
  # `pkgs.unstable.<name>`: opt-in bleeding edge for individual packages
  # without moving the whole system off the stable channel
  (_final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (prev.stdenv.hostPlatform) system;
      inherit (prev) config;
    };
  })
]
