#!/usr/bin/env bash
#
# Claude Code setup; safe to re-run.
#
# ~/.claude/settings.json stays a local file (its autoMode rules describe
# private infrastructure and only work in user settings), so the shared keys
# in claude/settings.json are merged into it: shared values win, lists are
# replaced.

# Unofficial Bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

cd "$(dirname "$0")"

settings="$HOME/.claude/settings.json"
mkdir -p "$(dirname "$settings")"
[[ -f $settings ]] || echo '{}' >"$settings"
jq -s '.[0] * .[1]' "$settings" claude/settings.json >"$settings.tmp"
mv "$settings.tmp" "$settings"

# enabledPlugins alone installs nothing on a new machine. The chrome-devtools-mcp
# clone (large submodule) outlives the default 120 s git timeout.
export CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS=540000
claude plugin marketplace add cloudflare/skills
for plugin in $(jq -r '.enabledPlugins | keys[]' claude/settings.json); do
  claude plugin install "$plugin"
done

# Credential-free, so scripted unlike the other user MCP servers: the vault
# unlocks through the server's native password dialog, never via the model.
# Remove + add so a version bump here reaches existing machines.
claude mcp remove --scope user bitwarden >/dev/null 2>&1 || true
claude mcp add --scope user bitwarden -- npx -y @bitwarden/mcp-server@2026.7.0

# Atuin's own installers: the user-scope MCP server (history search) and the
# Bash hooks that record Claude's commands in atuin history. Both are
# idempotent and pin the absolute atuin path, so re-run if atuin moves.
atuin mcp install claude-code
atuin hook install claude-code

# Writes the graphify skill and the /graphify block of ~/.claude/CLAUDE.md
# The sql + terraform extras add the SQL and HCL parsers; a plain install
# would drop them again
uv tool install 'graphifyy[sql,terraform]'
graphify install --platform claude

echo "Claude setup completed!"
