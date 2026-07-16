# Support passing additional arguments to subcommands like `make shellcheck .bashrc`.
args = $(filter-out $@,$(MAKECMDGOALS))

.DEFAULT_GOAL := all

# Run all the checks
.PHONY: all
all: lint

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
	shellcheck $(or $(args),$(filter-out %/zsh-aliasrc,$(SHELL_SCRIPTS)))

# Link all of the local repo files to the system
.PHONY: activate
activate:
	stow -vt ~ $(args)

# Unlink linked config directory
.PHONY: deactivate
deactivate:
	stow -D -vt ~ $(args)

# Print this help
.PHONY: help
help:
	@echo "COMMANDS"
	@echo
	@grep -E '^\.PHONY: [a-zA-Z_-]+ .*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = "(: |##)"}; {printf "  %-15s %s\n", $$2, $$3}'

# Wildcard target to support passing additional arguments to commands.
%:
	@:
