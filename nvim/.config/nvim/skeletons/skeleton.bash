#!/usr/bin/env bash
#
# {Description comment}

# A non-verbose  alternative to `set -o errexit -o nounset`
# Exits from the script on error (errexit) and treat unset variables as an error (nounset)
# Pipefail will fail the whole pipeline if any of the parts have failed
# `set -x` can be added to print lines before their execution - useful for debugging/CI
# All options: https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
# Unofficial Bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
# Internal Field Separator (IFS) - splits arrays on this sequence of characters
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
IFS=$'\n\t'
