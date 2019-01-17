#!/bin/bash

requester__new() {
    # Creates a new 'environment' for executing custom requests.

    if [ -z "$1" ]; then
        echo "Argument <env-name> required."
        echo "type 'help' for help."
    else
        mkdir "$1"
        cp -r ".methods/" "$1/"
        cp ".manage.sh" "$1/manage.sh"

        for method in $(ls .methods)
        do
            touch "$1/.methods/$method/.index.conf"
            echo -e "URL=\"\"\nVERBOSE=\"\"\nIGNORE_FILES=\"\"\nHEADERS=\"\"" > "$1/.methods/$method/.index.conf"

        done

        echo "Environment $1 created."
        echo "Perhaps is needed to configure it."
    fi
}

requester__help() {
    # Prompts a help message.

    echo "Welcome to the 'automated-requester' manager!"
    echo "Available commands: "
    echo ""
    echo -e "\tnew <env-name>\tCreates a new 'environment' for executing custom requests under a directory called <env-name>."
}

# "main" section

if declare -f "requester__$1" >/dev/null 2>&1; then
    "requester__$@"

else
    echo "Function '$1' not recognized" >&2
    requester__help
    exit 1
fi
