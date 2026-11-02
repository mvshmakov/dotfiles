# nix-darwin configuration and Homebrew migration runbook

Declarative macOS setup: [nix-darwin](https://github.com/nix-darwin/nix-darwin)
for the system (`/etc`, launchd, `defaults`, Homebrew bundle),
[home-manager](https://github.com/nix-community/home-manager) for user
packages and the dotfile symlinks, on top of
[Determinate Nix](https://docs.determinate.systems/).

home-manager links this directory to `~/.config/nix-darwin` like every other
package of the repo; `home/scripts/nix.sh` also symlinks it to
`/etc/nix-darwin` so a bare `sudo darwin-rebuild switch` finds it.

## Layout

```
flake.nix                      inputs (26.05 stable + unstable overlay), hosts, formatter, devShell
hosts/<LocalHostName>.nix      per-machine: platform, hostname, primary user
modules/darwin/
  nix.nix                      Determinate module, nix.custom.conf settings, nixpkgs config
  system.nix                   stateVersion, timezone, Touch ID sudo, macOS defaults (from macos.sh)
  shells.nix                   /etc/zshrc, /etc/bashrc generation, /etc/shells
  fonts.nix                    fonts (replaces the font casks)
  homebrew.nix                 taps/brews/casks/masApps kept in Homebrew
  window-manager.nix           yabai/skhd stay in Homebrew (why, and the nix-darwin alternative)
modules/home/
  default.nix                  home-manager entry
  packages.nix                 CLI tools migrated from the Brewfile
  dotfiles.nix                 the stow replacement: links every top-level repo dir into $HOME
overlays/default.nix           pkgs.unstable
```

## Commands

```bash
make nix-check     # build the whole system closure + nix-darwin's preflight checks (sudo, read-only), no activation
make nix-build     # just build (result symlink is gitignored)
make nix-switch    # sudo darwin-rebuild switch (activates!)
make nix-update    # bump flake.lock
make nix-fmt       # nix fmt (nixfmt via treefmt)
make nix-lint      # statix + deadnix
make nix-ci        # what CI runs: fmt --ci, lint, flake check, dry-run eval of every host (no root, no 12 GiB build)
```

With direnv, `cd`-ing into this directory (`.envrc`: `use flake`, allowed
once with `direnv allow`) puts nixfmt, statix, deadnix and the `nil`
language server on PATH; without direnv, `nix develop` does the same.

CI (`.github/workflows/lint.yaml`, job `nix`) installs Determinate Nix on a
macOS runner and runs `make nix-ci`, so CI and local checks share one
definition. The full closure build and `darwin-rebuild check` stay local:
one is ~12 GiB, the other needs root.

New files must be `git add`ed (or `git add -N`) before Nix sees them: a
flake inside a git repository evaluates the tracked tree only.

## Migration status

Configuration is complete for the whole migration (packages, casks, macOS
defaults, dotfile links, mise); the full closure builds and `make nix-ci`
passes. **Activation has not run yet**: it needs root, and the agent session
that prepared this is not allowed to modify the system. It is one command
sequence, run it from the repository root when no other agent is mid-task
(their next shells switch from Homebrew to Nix binaries; running shells are
untouched):

```bash
# 1. Unlink the stow symlinks (home-manager recreates every one of them)
rm -f ~/.config/brew
stow -D -t ~ --ignore='^/(scripts|macos|\.vscode)$' home
for p in */; do p=${p%/}; [ "$p" = home ] || stow -D -t ~ "$p"; done

# 2. Activate: /etc shell files, /etc/shells, Touch ID sudo, defaults,
#    fonts, home-manager packages + links, and `brew bundle --cleanup`
#    (uninstalls every formula that moved to nixpkgs, untaps unused taps)
sudo nix-darwin/.config/nix-darwin/result/sw/bin/darwin-rebuild switch \
  --flake ./nix-darwin/.config/nix-darwin
sudo ln -sfn "$PWD/nix-darwin/.config/nix-darwin" /etc/nix-darwin

# 3. Verify, in a NEW terminal
darwin-rebuild --list-generations
which -a git rg fd jq python3 make   # /etc/profiles/per-user/... first
ls -la ~/.config | head; ls -la ~/.zshenv ~/.ssh/config ~/Library/LaunchAgents
brew leaves                           # yabai skhd ssh-askpass shellfirm spotlighter i2p unbound mas zathura*

# 4. Runtimes: mise installs what ~/.tool-versions pins (prebuilt), then the
#    asdf/pyenv trees (~4 GB) can go
mise install && mise doctor
rm -rf ~/.asdf ~/.local/share/.pyenv

# 5. Reclaim disk
brew autoremove && brew cleanup -s --prune=all
nix store gc                          # drops the failed intermediate builds
```

If step 2 fails, nothing has been removed yet (cleanup runs last inside the
activation): re-link with `stow -t ~ --ignore='^/(scripts|macos|\.vscode)$'
home` and `for p in */; do ...stow -t ~ "$p"...; done`, and read the error.
Rollback after a successful switch: `sudo darwin-rebuild --rollback`
(Homebrew uninstalls are not rolled back; `brew bundle` from the previous
generation's Brewfile reinstalls them).

### What the switch changes on the machine

- `/etc/zshrc`, `/etc/zshenv`, `/etc/zprofile`, `/etc/bashrc`: replaced
  (current ones are the known Determinate/macOS variants, backed up as
  `*.before-nix-darwin`). `/etc/shells` gains the Nix shells,
  `/etc/pam.d/sudo_local` gets Touch ID, `/etc/nix/nix.custom.conf` is
  regenerated with the same settings.
- `system.defaults` from `system.nix` are applied; fonts land in
  `/Library/Fonts/Nix Fonts` (the font casks are removed).
- `/etc/profiles/per-user/mvshmakov` gets the 130+ CLI tools; `$HOME` gets
  the 50+ symlinks from `dotfiles.nix` (same targets stow created).
- Homebrew: the ~100 migrated formulae and their dependencies are
  uninstalled, unused taps untapped, no cask is installed or upgraded
  (declared == installed). Expect roughly 10 GB back from the Cellar.

### Still open

- **nix-homebrew** (pin the Homebrew installation itself): optional, see
  Design decisions.
- **Secrets** (`~/.ssh/config.d/`): sops-nix, see Private data below.
- `home/.bash_profile` still runs `rbenv init` (no rbenv installed); bash is
  not the login shell, low priority.

## Design decisions

- **Stable 26.05 + unstable overlay** (`pkgs.unstable.<name>`): the same
  split as the old 2022 flake, using the darwin-specific stable branch.
- **Determinate module instead of `nix.enable = true`**: Determinate Nix
  aborts nix-darwin activation otherwise ("Determinate detected").
  `nix.settings`, `nix.gc`, `nix.optimise`, `nix.linux-builder` are
  therefore unavailable; use `determinateNix.customSettings` and
  `determinateNixd`.
- **Dotfiles are out-of-store symlinks** (`dotfiles.nix`): the repo keeps
  its stow layout, home-manager creates the same links, edits apply without
  a rebuild. `programs.*` modules are not used for linked directories: they
  would back up / replace the tracked files.
- **Toolchains**: `mise` for `.tool-versions` projects (prebuilt runtimes),
  `use flake` + nix-direnv for projects with a flake. asdf, pyenv, pipenv
  and the brew-libs direnv helper are gone.
- **yabai/skhd stay in Homebrew**: nixpkgs' ad-hoc signed binaries lose
  their Accessibility grants on every update (`window-manager.nix`).
- **Casks stay in Homebrew**, fonts move to `fonts.packages`, CLI tools
  move to nixpkgs. Exceptions kept as brews with reasons in `homebrew.nix`
  (`inetutils`, `i2p`, `ssh-askpass`, `shellfirm`, `spotlighter`, `mas`,
  `unbound`, zathura + plugins, yabai/skhd until phase 2).
- **No unfree packages**: `allowUnfree = false`, no allowlist. `ngrok` is
  the cask; `terraform`, `inetutils` and the CC BY-NC `xkcd-font` were
  dropped as unused (OpenTofu and `nc` cover the first two).
- **PATH order**: `.zprofile` re-prepends the Nix profiles after
  `brew shellenv`, so Nix binaries win over the casks' CLIs.

## Behaviour differences to know about

- `make` is GNU make 4.x from Nix (brew installed it as `gmake`).
- `curl` stays Apple's: nix's curl does not use the Keychain CA store.
- `postgresql@16` was installed alongside 18; only `postgresql_18` is
  declared (it also provides `libpq`/`psql`).
- One shared `python3` env provides `jupyter-lab` and `tkinter`; `uv`,
  `pyenv`, `pipenv`, `asdf` stay for project interpreters.
- `terraform` (brew, `hashicorp/tap`) and `inetutils` are no longer
  declared: phase 2's cleanup uninstalls them. Nothing in the repo or the
  shell history used either.
- `zathura` could not move: all nixpkgs zathura plugins build-depend on
  `appstream`, which fails to compile on darwin in nixpkgs 26.05 (verified
  during the e2e build); retry after a nixpkgs bump.
- `texliveMedium` is a multi-GB closure; drop to `texliveSmall` +
  `latexmk` if disk matters.
- `time.timeZone` is set to Europe/Berlin (the machine's current zone;
  `macos.sh` still had Europe/Moscow).
- Brew leaves that were only build dependencies (`adwaita-icon-theme`,
  `desktop-file-utils`, `gtk-mac-integration`, `intltool`, `jpeg`,
  `libultrahdr`, `zplug`) were not migrated; `brew autoremove` will drop them
  in phase 2.

## Private data (SSH config)

`home/.ssh/config` holds only generic settings and public hosts. Hosts that
must not be public live in `~/.ssh/config.d/`, outside the repo, pulled in
by `Include config.d/*` at the top of the tracked file (first match wins,
so they keep precedence over `Host *`). `dotfiles.nix` links
`~/.ssh/config` alone, so `~/.ssh/config.d/` stays a plain local directory.

Next step: generate `~/.ssh/config.d/private` from an encrypted file with
[sops-nix](https://github.com/Mic92/sops-nix) (home-manager module, an
`age` key; a YubiKey-backed `age-plugin-yubikey` identity fits the existing
GPG/YubiKey setup), so a new machine gets it on `darwin-rebuild switch`.
The same covers `known_hosts`, `authorized_keys` and any future token.
Older versions of the file in this repo's history held some host
addresses; treat those as public.
