#!/bin/bash

CONFIG_FILE=".index.conf"

manage__seturl() {
    # Sets or resets the URL parameter for the request.

    local NEW_VAL=$1
    local TARGET="URL"
    sed -i "s/\(^$TARGET *= *\).*/\1$NEW_VAL/" $CONFIG_FILE
}

manage__setverbose() {
    # Sets or resets the VERBOSE option of the curl.

    sed -i "s/\(VERBOSE *= *\).*/\1$1/" $CONFIG_FILE
}

manage__setignore() {
    # Adds a new list of ignored files.

    sed -i "s/\(VERBOSE *= *\).*/\1${@}/" $CONFIG_FILE
}

manage__setheader() {
    # Adds a new list of ignored files.

    sed -i "s/\(VERBOSE *= *\).*/\1${@}/" $CONFIG_FILE
}

manage__run() {
    # Calls the bash to execute the request.

    local target=${1,,}
    for folder in $(ls .methods)
    do
        if [[ $folder == $target ]]; then
            bash .methods/${target}/${target^^}.sh
            exit 0
        fi

    done

    echo "The method required $target isn't available yet."
    exit 1
}

manage__help() {
    # Prompts a help message.

    echo "Commands available to manage the environment:"
    echo ""
    echo -e "run <method>\t\tSends an HTTP request with the specified method."
    echo -e "seturl <url>\t\tSets a new url value to send the requisitions."
    echo -e "setverbose <option>\tWhether enable or not the verbose mode for the curl command (0 - No/1 - Yes)."
    echo -e "setignore <filelist>\tAdds a list of files from the _params/ folder to be not considered when building the data. Separed by spaces"
    echo -e "setheader <headerlist>\tAdds a list of HTTP headers to be set as RequestHeader. Separed by spaces."
    echo -e "help\t\t\tPrompts this message."
}

# "main" section

if declare -f "manage__$1" >/dev/null 2>&1; then
    "manage__$@"

else
    echo "Function '$1' not recognized" >&2
    manage__help
    exit 1
fi
