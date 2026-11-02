# Host-specific values; everything shared lives in ../modules
{ username, hostname, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Keeps the current names (no-op on this machine); makes the reinstall
  # reproducible on a fresh one
  networking = {
    hostName = hostname;
    computerName = hostname;
    localHostName = hostname;
  };

  # nix-darwin runs as root now; user-scoped options (homebrew, defaults,
  # launchd user agents) apply to this user
  system.primaryUser = username;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };
}
