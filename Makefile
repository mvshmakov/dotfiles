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
	$(MAKE) lint-shell

.PHONY: lint-shell ## Run shellcheck on relevants scripts
lint-shell:
	find $(or $(args),./bin/.local/bin) -maxdepth 1 -type f -exec shellcheck {} +

.PHONY: activate ## Link all of the local repo files to the system
activate:
	stow -vt ~ $(args)

.PHONY: deactivate ## Unlink linked config directory
deactivate:
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
