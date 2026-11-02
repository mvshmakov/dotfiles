# Support passing additional arguments to subcommands like `make shellcheck .bashrc`.
args = $(filter-out $@,$(MAKECMDGOALS))

.DEFAULT_GOAL := all

# Run all the checks
.PHONY: all
all: lint nix-ci

# Using .PHONY to avoid conflicts with files named the same as the target
# E.g., `shellcheck` exists in both filesystem and in the commands
.PHONY: lint ## Lint and check formatting of shell scripts
lint:
	$(MAKE) format-check
	$(MAKE) lint-shell

# First-party shell scripts to lint. Explicit paths + -maxdepth 1 keep
# submodules (yubitouch), vendored tmux plugins and .history out of scope -
# that code is not ours to format
SHELL_SCRIPTS = $(shell find ./bin/.local/bin ./home/scripts ./home/shell-sources -maxdepth 1 -type f) ./direnv/.config/direnv/direnvrc

# Verify shell script formatting
.PHONY: format-check
format-check:
	shfmt -i 2 -ci -bn -l -d $(or $(args),$(SHELL_SCRIPTS))

# Run shellcheck on relevant scripts
# zsh files are excluded: shellcheck does not support zsh
.PHONY: lint-shell
lint-shell:
	shellcheck $(or $(args),$(filter-out %/zsh-aliasrc %/docker-weekly-prune,$(SHELL_SCRIPTS)))

# nix-darwin flake (stowed to ~/.config/nix-darwin); the darwinConfigurations
# attribute is the machine's LocalHostName
NIX_FLAKE = ./nix-darwin/.config/nix-darwin
NIX_HOST = $(shell scutil --get LocalHostName)
NIX_SYSTEM = $(NIX_FLAKE)\#darwinConfigurations.$(NIX_HOST).system

# Build the whole system closure without activating anything
.PHONY: nix-build ## Build the nix-darwin system closure (no activation)
nix-build:
	nix build $(NIX_SYSTEM) -o $(NIX_FLAKE)/result

# Build + run nix-darwin's preflight checks (existing /etc files, primary
# user, Homebrew present, ...); read-only, but darwin-rebuild insists on root
# for every action that could activate, `check` included
.PHONY: nix-check ## Build + nix-darwin preflight checks (no activation)
nix-check: nix-build
	sudo $(NIX_FLAKE)/result/sw/bin/darwin-rebuild check --flake $(NIX_FLAKE)

# Activate: writes /etc, launchd agents, defaults and runs `brew bundle`
.PHONY: nix-switch ## Activate the configuration (sudo)
nix-switch:
	sudo darwin-rebuild switch --flake $(NIX_FLAKE) || \
	  sudo nix run nix-darwin/nix-darwin-26.05\#darwin-rebuild -- switch --flake $(NIX_FLAKE)

.PHONY: nix-update ## Update flake.lock
nix-update:
	nix flake update --flake $(NIX_FLAKE)

.PHONY: nix-fmt ## Format the Nix files
nix-fmt:
	cd $(NIX_FLAKE) && nix fmt

# `--ci` = fail on unformatted files without rewriting them
.PHONY: nix-fmt-check
nix-fmt-check:
	cd $(NIX_FLAKE) && nix fmt -- --ci

.PHONY: nix-lint ## Lint the Nix files (statix + deadnix)
nix-lint:
	nix develop $(NIX_FLAKE) -c statix check $(NIX_FLAKE)
	nix develop $(NIX_FLAKE) -c deadnix --fail $(NIX_FLAKE)

# Flake-level sanity: lock file, outputs schema, devShell/formatter eval
.PHONY: nix-flake-check
nix-flake-check:
	cd $(NIX_FLAKE) && nix flake check

# Evaluate every darwinConfiguration fully (all modules, options and
# package attributes) without downloading or building the closure
.PHONY: nix-eval
nix-eval:
	for host in $$(nix eval --raw $(NIX_FLAKE)\#darwinConfigurations --apply 'c: builtins.concatStringsSep " " (builtins.attrNames c)'); do \
	  nix build --dry-run $(NIX_FLAKE)\#darwinConfigurations.$$host.system || exit 1; \
	done

# Everything CI runs for the Nix side; needs no root and no full build
.PHONY: nix-ci ## Nix checks as run in CI (format, lint, evaluate)
nix-ci: nix-fmt-check nix-lint nix-flake-check nix-eval

# Print this help
.PHONY: help
help:
	@echo "COMMANDS"
	@echo
	@grep -E '^\.PHONY: [a-zA-Z_-]+ .*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = "(: |##)"}; {printf "  %-15s %s\n", $$2, $$3}'

# Wildcard target to support passing additional arguments to commands.
%:
	@:
