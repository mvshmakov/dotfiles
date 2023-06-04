#!/usr/bin/env sh
#
# {Description comment}

# A non-verbose  alternative to `set -o errexit -o nounset`
# Exits from the script on error (errexit) and treat unset variables as an error (nounset)
# `set -x` can be added to print lines before their execution - useful for debugging/CI
# All options: https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
# Unofficial POSIX strict mode: https://gist.github.com/EvgenyOrekhov/5c1418f4710558b5d6717d9e69c6e929
set -eu
# Internal Field Separator (IFS) - splits arrays on this sequence of characters
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
IFS=$(printf '\n\t')
