#!/bin/bash

#
# The goal of this script is to let you run a command against each file
# matching a glob expression in a borg archive, without actually extracting
# the files.
#
# The content of each file is piped to the command supplied. Because of this
# the filename will not be known to the command. Perhaps this needs to be
# addressed in some way.
#

if [[ $# -lt 3 ]]; then
    cat <<EOF
usage: $0 <borg archive> <command> <glob expression> [<glob expression> ...]
EOF
    exit 1
fi

borg list --short $1 | while IFS= read -r f; do
    for g in "${@:3}"; do
        if [[ $f == $g ]]; then
            echo $f:
            borg extract --stdout $1 $f | $2
        fi
    done
done
