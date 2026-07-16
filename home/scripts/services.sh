#!/usr/bin/env bash
#
# Bootstrap the window manager launchd services (yabai + skhd)

# Unofficial Bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# The service plists are versioned in launchctl/ and stowed into
# ~/Library/LaunchAgents, so the official service commands only need to
# (un)bootstrap them. Never run `--install-service`/`--uninstall-service`:
# through the stow symlink they would overwrite/delete the tracked plists.
for service in yabai skhd; do
  # A full stop + start re-bootstraps the job so launchd picks up plist
  # changes (e.g. environment variables); `--restart-service` alone only
  # restarts the process within the already-bootstrapped job
  "$service" --stop-service 2>/dev/null || true
  "$service" --start-service
done

echo "yabai + skhd services started!"
echo "On a new machine, grant Accessibility (yabai + skhd) and Input Monitoring (skhd) in System Settings -> Privacy & Security."
