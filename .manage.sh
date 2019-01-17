#!/bin/bash
#set -u

manage__seturl() {
    # Sets or resets the URL parameter for the request.

    local NEW_VAL=$1; shift
    local CONFIG_FILE=$1; shift
    sed -i "s_\(^URL=*\).*_\1${NEW_VAL}_" "$CONFIG_FILE"
}

manage__setverbose() {
    # Sets or resets the VERBOSE option of the curl.

    local NEW_VAL=$1; shift
    local CONFIG_FILE=$1; shift
    sed -i "s_\(^VERBOSE=*\).*_\1${NEW_VAL}_" $CONFIG_FILE
}

manage__setignore() {
    # Adds a new list of ignored files.

    local NEW_VAL=$1; shift
    local CONFIG_FILE=$1; shift
    sed -i "s_\(^IGNORE\_FILES=*\).*_\1\"${NEW_VAL}\"_" $CONFIG_FILE
}

manage__setheader() {
    # Adds a new list of ignored files.

    local NEW_VAL=$1; shift
    local CONFIG_FILE=$1; shift
    sed -i "s_\(^HEADERS=*\).*_\1\"${NEW_VAL}\"_" $CONFIG_FILE
}

manage__run() {
    # Calls the bash to execute the request.

    local target=${1,,}
    for folder in $(ls .methods); do
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

    echo "Commands available to manage the workspace:"
    echo ""
    echo -e "\trun <method>\t\tSends an HTTP request with the specified method."
    echo -e "\thelp\t\t\tPrompts this message."
    echo "The following commands changes only the configuration for the provided <method>."
    echo -e "\tseturl <url> -m <method>\t\tSets a new url value to send the requisitions."
    echo -e "\tsetverbose <option> -m <method>\tWhether enable or not the verbose mode for the curl command (0 - No/1 - Yes)."
    echo -e "\tsetignore <filelist> -m <method>\tAdds a list of files from the _params/ folder to be not considered when building the data."
    echo -e "\tsetheader <headerlist> -m <method>\tAdds a list of HTTP headers to be set as RequestHeader."
}

# "main" section

while getopts 'm:' OPTION; do
    case $OPTION in
        m)
            CONF_FILE=".methods/${OPTARG,,}/.index.conf"
            ;;

        ?)
            echo "WTF??"
            ;;

    esac
done

#echo $CONFIG_FILE >&2

shift $(($OPTIND -1))

if declare -f "manage__$1" >/dev/null 2>&1; then
    manage__"$@" $CONF_FILE

else
    echo "Function '$1' not recognized" >&2
    manage__help
    exit 1
fi
