#!/bin/bash
set -u
set -e

manage__addparam() {
    # Adds a new parameter file to the list.

    local PARAM_FILE=$1; shift
    local METHOD=$1; shift
    cp $PARAM_FILE .methods/${METHOD}/_params/

}

# TODO the methods to change the config files can be nested in only one func

manage__seturl() {
    # Sets or resets the URL parameter for the request.

    local NEW_VAL=$1; shift
    local METHOD=$1; shift
    local CONFIG_FILE=".methods/${METHOD}/.index.conf"

    sed -i "s_\(^URL=*\).*_\1${NEW_VAL}_" "$CONFIG_FILE"
}

manage__setverbose() {
    # Sets or resets the VERBOSE option of the curl.

    local NEW_VAL=$1; shift
    local METHOD=$1; shift
    local CONFIG_FILE=".methods/${METHOD}/.index.conf"

    sed -i "s_\(^VERBOSE=*\).*_\1${NEW_VAL}_" $CONFIG_FILE
}

manage__setignore() {
    # Adds a new list of ignored files.

    local NEW_VAL=$1; shift
    local METHOD=$1; shift
    local CONFIG_FILE=".methods/${METHOD}/.index.conf"

    sed -i "s_\(^IGNORE\_FILES=*\).*_\1\"${NEW_VAL}\"_" $CONFIG_FILE
}

manage__setheader() {
    # Adds a new list of ignored files.

    local NEW_VAL=$1; shift
    local METHOD=$1; shift
    local CONFIG_FILE=".methods/${METHOD}/.index.conf"

    sed -i "s_\(^HEADERS=*\).*_\1\"${NEW_VAL}\"_" $CONFIG_FILE
}

manage__showconfig() {
    # Prompts the configuration file for a specified

    local CONFIG_FILE=$1; shift
    cat $CONFIG_FILE
}

manage__run() {
    # Calls the bash to execute the request.

    local target=${1,,}; shift
    bash .methods/${target}/${target^^}.sh
    exit 0

    echo -e "\e[31;1mERROR:\e[0m The required method $target isn't available yet."
    exit 1
}

manage__help() {
    # Prompts a help message.

    echo "Try one of the commands bellow:"
    echo ""
    echo -e "\trun <method>\t\tSends an HTTP request with the specified method."
    echo -e "\t-h\t\t\tPrompts this message."
    echo ""
    echo "  The following commands changes only the configuration for the provided <method>."
    echo -e "\theader <headerlist> -m <method>\tAdds a list of HTTP headers to be set as RequestHeader."
    echo -e "\tignore <filelist> -m <method>\tAdds a list of files from the _params/ folder to be not considered when building the data."
    echo -e "\tparam <filepath> -m <method>\tAdds a new parameter file from <filepath> to the param list of <method>."
    echo -e "\tshowconfig <method>\t\tDisplays the current confiration file for <method>."
    echo -e "\turl <url> -m <method>\t\tSets a new url value to send the requisitions."
    echo -e "\tverbose <option> -m <method>\tWhether enable or not the verbose mode for the curl command (0 - No/1 - Yes)."
}

# "main" section

while getopts ':h' opt; do
    case $opt in
        h )
            manage__help

            exit 0
            ;;

        \? )
            echo -e "\e[31;1mERROR:\e[0m '${opt}' is a invalid option!!"
            manage__help

            exit 1
            ;;

    esac
done
shift $(($OPTIND -1))

subcommand=$1; shift

case $subcommand in

    run )
        method=$1; shift
        if [ -z $method ]; then
            echo -e "\e[31;1mERROR:\e[0m <method> argument is required!!"

            exit 1

        else
            manage__run $method

            exit 0
        fi
        ;;

    showconfig )
        method=$1;
        if [ -z $method ]; then
            echo -e "\e[31;1mERROR:\e[0m <method> argument is required!!"

            exit 1
        else
            CONFIG_FILE=".methods/${method,,}/.index.conf"
            manage__showconfig $CONFIG_FILE

            exit 0
        fi
        ;;
# The code bellow could be set in a only condition
    url )
        func="seturl";
        args=$1; shift
        ;;

    verbose )

        func="setverbose";
        args=$1; shift
        ;;

    ignore )

        func="setignore";
        args=$1; shift
        ;;

    header )
        func="setheader";
        args=$1; shift
        ;;

    param )
        func="addparam";
        while getopts ":rpn" opt; do
            case ${opt} in
                r )
                    echo "RAND" >&2
                    ;;

                p )
                    echo "PATHV" >&2
                    ;;

                n )
                    echo "NEW FILE" >&2
                    ;;

                \? )
                    echo "AAAA: -$OPTARG" >&2
                    ;;
            esac
        done
        shift $((OPTIND -1))

        args=$1; shift
        ;;

    * )
        echo -e "\e[31;1mERROR:\e[0m '$subcommand' is not a valid command!!"
        manage__help

        exit 1
        ;;

esac

# options for the method-specific
m_flag=false

while getopts ':m:' opt; do
    case ${opt} in
        m )
            METHOD=${OPTARG,,}
            manage__$func $args $METHOD

            m_flag=true
            ;;
        \? )
            echo -e "\e[31;1mERROR:\e[0m '$opt' is an invalid option for function $func!!"

            exit 1
            ;;
    esac
done
shift $(($OPTIND -1))

if ! $m_flag; then
    echo -e "\e[31;1mERROR:\e[0m the -m option is mandatory for subcommand '$func'."

    exit 1
fi


#if declare -f "manage__$subcommand" >/dev/null 2>&1; then
#    manage__$subcommand $args $CONF_FILE

#else
#    echo "Function '$1' not recognized" >&2
#    manage__help
#    exit 1
#fi
