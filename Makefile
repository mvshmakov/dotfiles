# Support passing additional arguments to subcommands like `make shellcheck .bashrc`.
args = $(filter-out $@,$(MAKECMDGOALS))

.DEFAULT_GOAL := all

.PHONY: all ## Run all the checks
all:
	lint

# Using .PHONY to avoid conflicts with files named the same as the target
# E.g., `shellcheck` exists in both filesystem and in the commands
.PHONY: lint ## Lint and format the shell scripts
lint:
	$(MAKE) fmt-check
	$(MAKE) lint-shell

.PHONY: fmt-check ## Verify shell script formatting
fmt-check:
	shfmt -i 2 -ci -bn -l -d .

.PHONY: lint-shell ## Run shellcheck on relevant scripts
lint-shell:
	shellcheck $(or $(args),$(shell find ./bin/.local/bin -maxdepth 1 -type f -not -name optimize_spotlight))

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
