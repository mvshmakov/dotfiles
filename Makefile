# Support passing additional arguments to subcommands like `make shellcheck .bashrc`.
args = $(filter-out $@,$(MAKECMDGOALS))

.DEFAULT_GOAL := all

.PHONY: all ## Run all the checks
all:
	lint

# Using .PHONY to avoid conflicts with files named the same as the target
# E.g., `shellcheck` exists in both filesystem and in the commands
.PHONY: lint ## Lint all the scripts in the codebase
lint:
	lint-shell

.PHONY: lint-shell ## Run shellcheck on relevants scripts
lint-shell:
	shellcheck $(args) || ./bin/.local/bin/*

.PHONY: activate ## Link all of the local repo files to the system
activate:
	stow -vt ~ $(args)

.PHONY: deactivate ## Unlink linked config directory
activate:
	stow -D -vt ~ $(args)

.PHONY: help ## Print this help
help:
	@echo "COMMANDS"
	@echo
	@grep -E '^\.PHONY: [a-zA-Z_-]+ .*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = "(: |##)"}; {printf "  %-15s %s\n", $$2, $$3}'

# Wildcard target to support passing additional arguments to commands.
# This is required to ensure `make shellcheck .bashrc` does what you expect.
%:
	@:
