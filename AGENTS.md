# AGENTS

## Testing

- Run `make lint` to check formatting and lint shell scripts.
- Run `make nix-ci` to format-check, lint and evaluate the nix-darwin flake (no root, no full build).

## Commit Style

- Follow the commit guidelines in `CONTRIBUTING.md`.
- Use lower case imperative mood in headers.
- Keep subject under 50 characters and body lines under 72 characters.

## Pull Requests

- Summarize changes under a **Summary** section.
- Include a **Testing** section describing verification steps.

## Coding Conventions

- Format shell scripts with `shfmt` using two-space indentation.
- Lint shell scripts with `shellcheck` using `shellcheck/.config/shellcheckrc`.
- Prefer spaces over tabs in all files.

## Skills

Agent skills live in `.agents/skills/` (canonical, read by Codex) with
symlinks in `.claude/skills/` (Claude Code), pinned in `skills-lock.json` and
managed with the [skills CLI](https://skills.sh):

- `nix-best-practices` (alleneubank/claude-code) - flakes, overlays,
  dev shells, direnv. Repo conventions win where they differ: the runbook in
  `nix-darwin/.config/nix-darwin/README.md` (unfree is an explicit allowlist,
  dotfiles are out-of-store symlinks via `dotfiles.nix`, no home-manager
  `programs.*` modules for linked directories).
- `shellcheck-configuration`, `bash-defensive-patterns` (wshobson/agents) -
  the shell scripts are linted with `make lint`; `shellcheck/.config/shellcheckrc`
  is the project config.
- `github-actions-templates` (wshobson/agents) - `.github/workflows/lint.yaml`.
- `find-skills` (vercel-labs/skills) - how to search skills.sh and vet a
  skill (install count, source, stars) before recommending it. Its install
  step suggests `-g` (global); in this repo install project-level with the
  command below so the skill is committed and shared with every agent.

```bash
npx skills add <owner/repo> -s <skill> -a claude-code -a codex -y  # add
npx skills update                                                  # refresh to upstream
npx skills list
```
