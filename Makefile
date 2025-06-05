# Support passing additional arguments to subcommands like `make shellcheck .bashrc`.
args = $(filter-out $@,$(MAKECMDGOALS))

.DEFAULT_GOAL := all

# Run all the checks
.PHONY: all
all:
	lint

# Using .PHONY to avoid conflicts with files named the same as the target
# E.g., `shellcheck` exists in both filesystem and in the commands
.PHONY: lint ## Lint all the scripts in the codebase
lint:
	$(MAKE) lint-shell

# Run shellcheck on relevant scripts
# Restricts search to avoid shellchecking submodules
.PHONY: lint-shell
lint-shell:
	find $(or $(args),./bin/.local/bin) -maxdepth 1 -type f -exec shellcheck {} +

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
# This is required to ensure `make shellcheck .bashrc` does what you expect.
%:
	@:
