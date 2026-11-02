# Host-specific values; everything shared lives in ../modules. The
# machine's own names (ComputerName, LocalHostName) are left to macOS: the
# configuration name is neutral on purpose.
{ username, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  # nix-darwin runs as root now; user-scoped options (homebrew, defaults,
  # launchd user agents) apply to this user
  system.primaryUser = username;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };
}
