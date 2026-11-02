{
  description = "mvshmakov's macOS configuration (nix-darwin + home-manager on Determinate Nix)";

  inputs = {
    # Stable package set (darwin-specific channel, tracks nixos-26.05 with
    # darwin fixes cherry-picked faster); `pkgs.unstable.<name>` is available
    # through the overlay for the few packages that need to be newer
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # System management (/etc, launchd, macOS defaults, Homebrew bundle)
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # User environment (packages; dotfiles stay stow-managed, see README.md)
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Determinate Nix owns /etc/nix/nix.conf and the daemon; this module
    # makes nix-darwin compatible with it (nix.enable = false) and exposes
    # /etc/nix/nix.custom.conf as `determinateNix.customSettings`.
    # Upstream recommends NOT adding a nixpkgs `follows` here (cache misses).
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";

    # Pre-built nix-index database, powers `comma` (`, cowsay hi`) and
    # command-not-found without hours of local indexing
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      username = "mvshmakov";

      # One entry per machine; the attribute name must match
      # `scutil --get LocalHostName` so that a bare `darwin-rebuild switch`
      # picks the right one
      mkDarwinHost =
        hostname:
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs username hostname;
          };
          modules = [
            ./modules/darwin
            ./hosts/${hostname}.nix

            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "hm-backup";
                extraSpecialArgs = {
                  inherit inputs username;
                };
                users.${username} = import ./modules/home;
              };
            }
          ];
        };

      forEachDarwin =
        f:
        nixpkgs.lib.genAttrs [ "aarch64-darwin" "x86_64-darwin" ] (
          system: f nixpkgs.legacyPackages.${system}
        );
    in
    {
      darwinConfigurations = {
        mvshmakov-neocom-mbp-14 = mkDarwinHost "mvshmakov-neocom-mbp-14";
      };

      # `nix fmt` formats the tree with nixfmt (RFC 166 style, the nixpkgs
      # standard) through treefmt; `nix fmt -- --ci` only checks
      formatter = forEachDarwin (pkgs: pkgs.nixfmt-tree);

      # `nix develop` while editing this configuration
      devShells = forEachDarwin (pkgs: {
        default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            nixfmt
            statix
            deadnix
            nil
          ];
        };
      });
    };
}
