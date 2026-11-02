#!/usr/bin/env bash
# Install (or re-install after `brew upgrade tailmux`) tailmux as a hardened
# root LaunchDaemon in TUN mode.
#
# Why not `sudo brew services start tailmux`: that runs a binary under the
# user-owned /opt/homebrew/opt as root, and tailmux re-execs itself as root
# whenever that path changes, so any code running as the user gets root
# (security audit 2026-10-20). This script copies the binary, config and
# state into root-owned paths and installs its own LaunchDaemon.
#
# Usage (from a terminal, needs the admin password):
#   sudo ~/projects/personal/dotfiles/home/scripts/tailmux-root-install.sh
#
# Hand upgrade: `brew upgrade growlyx/tap/tailmux`, review the diff first
# (internal/update, internal/mux/{http,manage,localapi}.go,
# internal/tun/os_darwin.go), then re-run this script.
#
# Paths:
#   /usr/local/libexec/tailmux                     binary (root:wheel 0755)
#   /Library/Application Support/tailmux/config.json  config (root:wheel 0600)
#   /var/db/tailmux/                               state  (root:wheel 0700)
#   /Library/LaunchDaemons/local.tailmux.plist     daemon
#   /var/log/tailmux.log                           log
#   /Applications/TailmuxBar.app                   menu bar app (user-owned,
#     installed once with `tailmux bar` as the user, launched at login by
#     launchctl/Library/LaunchAgents/com.github.growlyx.tailmux.bar.plist)
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "run with sudo" >&2
  exit 1
fi

# Sources live next to this script in the dotfiles checkout
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
src_dir=$script_dir/../../tailmux/.config/tailmux
src_config=$src_dir/config.json
src_plist=$src_dir/local.tailmux.plist

brew_prefix=/opt/homebrew
brew_bin=$brew_prefix/opt/tailmux/bin/tailmux
brew_state=$brew_prefix/var/lib/tailmux
brew_config=$brew_prefix/etc/tailmux/config.json
brew_plist=/Library/LaunchDaemons/sh.brew.tailmux.plist

bin=/usr/local/libexec/tailmux
config_dir="/Library/Application Support/tailmux"
config="$config_dir/config.json"
state_dir=/var/db/tailmux
plist=/Library/LaunchDaemons/local.tailmux.plist
label=local.tailmux

for f in "$src_config" "$src_plist" "$brew_bin"; do
  [[ -e $f ]] || {
    echo "missing: $f" >&2
    exit 1
  }
done

# Every directory on the binary path must be root-owned, or the whole point
# is lost
for d in /usr /usr/local /usr/local/libexec; do
  owner=$(stat -f '%u' "$d")
  [[ $owner == 0 ]] || {
    echo "$d is not root-owned (uid $owner); refusing" >&2
    exit 1
  }
done

echo "==> stopping any running tailmux daemon"
launchctl bootout system/"$label" 2>/dev/null || true
launchctl bootout system/sh.brew.tailmux 2>/dev/null || true
rm -f "$brew_plist"
# Wait for routes/resolvers to be torn down before the new daemon re-adds them
sleep 2

echo "==> binary -> $bin"
install -o root -g wheel -m 0755 "$brew_bin" "$bin"

echo "==> config -> $config"
install -d -o root -g wheel -m 0700 "$config_dir"
install -o root -g wheel -m 0600 "$src_config" "$config"

echo "==> state -> $state_dir"
install -d -o root -g wheel -m 0700 "$state_dir"
if [[ -d $brew_state/personal && ! -d $state_dir/personal ]]; then
  # Keep the signed node key from the Homebrew-era install
  ditto "$brew_state/personal" "$state_dir/personal"
fi
chown -R root:wheel "$state_dir"
chmod -R go-rwx "$state_dir"

echo "==> removing Homebrew-era state"
rm -rf "$brew_state"
# The user's `tailmux` CLI reads the API address from the Homebrew default
# config path; keep that a link to the dotfiles file. Only the daemon's
# root-owned copy matters for security.
ln -sfn "$src_config" "$brew_config"

# `sudo brew services` made the keg root-owned; hand it back so plain
# `brew upgrade` works again. The running copy is $bin, not the keg.
echo "==> restoring user ownership of the Homebrew keg"
keg_owner=$(stat -f '%u:%g' "$brew_prefix/bin")
chown -h "$keg_owner" "$brew_prefix/opt/tailmux" \
  "$brew_prefix/var/homebrew/linked/tailmux" 2>/dev/null || true
chown -R "$keg_owner" "$brew_prefix"/Cellar/tailmux

echo "==> daemon -> $plist"
install -o root -g wheel -m 0644 "$src_plist" "$plist"
touch /var/log/tailmux.log
chown root:wheel /var/log/tailmux.log
chmod 0600 /var/log/tailmux.log
launchctl bootstrap system "$plist"
launchctl kickstart -k system/"$label"

# Menu bar app: root never touches /Applications (TAILMUX_NO_APPLICATIONS);
# refresh the user's copy from the keg as the user, if they installed it
# with `tailmux bar`
bar_app=/Applications/TailmuxBar.app
if [[ -n ${SUDO_USER:-} && -d $bar_app && -d $brew_prefix/opt/tailmux/TailmuxBar.app ]]; then
  echo "==> refreshing $bar_app as $SUDO_USER"
  sudo -u "$SUDO_USER" ditto "$brew_prefix/opt/tailmux/TailmuxBar.app" "$bar_app"
  sudo -u "$SUDO_USER" launchctl kickstart -k \
    "gui/$(id -u "$SUDO_USER")/com.github.growlyx.tailmux.bar" 2>/dev/null || true
fi

sleep 3
echo "==> done; status:"
launchctl print system/"$label" | grep -E 'state|pid' | head -2
"$bin" -config "$config" status || true
