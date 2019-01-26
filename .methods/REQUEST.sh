#!/bin/bash
#set -u
set -e

METHOD=$1; shift

. .methods/${METHOD}/.index.conf

ignored=($IGNORE_FILES)
url=$URL
data=""

is_in() {
    # Tests if a value is in an array.

    local target=$1; shift
    local arr=("$@")
    local in=false

    for i in "${arr[@]}"; do
        if [[ $i == $target ]]; then
            in=true
            break
        fi
    done

    echo "$in"

    return 0
}

set_url() {
    # Sets the url according to path vars

    vars=$1; shift
    temp=$URL

    if [[ "${URL: -1}" == "/"  ]]; then
        echo "${URL}${vars}"

    else
        echo "${URL}/${vars}"

    fi
    
    return 0
}

get_value() {
    # Generates a value for the respective key.

	local header=$1; shift
	local _file=$1; shift
	if [[ $header == "__TYPE@RANDOMNUMBER__" ]]; then
        local min=$(sed "2q;d" ".methods/$METHOD/_params/${_file}")
        local max=$(sed "3q;d" ".methods/$METHOD/_params/${_file}")
        local diff=$((max - min + 1))
        local value=$(( ($RANDOM % diff) + min ))

    else
        local n_of_lines=$(wc -l < ".methods/$METHOD/_params/${_file}")
        local f_line=$(( ($RANDOM % n_of_lines) + 1  ))
        local value=$(sed "${f_line}q;d" ".methods/$METHOD/_params/${_file}")
    fi
    
    echo $value
    
    return 0
}

parse_data() {
    # Assembles a JSON-like string variable with
    # keys being the name of the files found in /_params
    # and the values being random lines of this files.

    local _data="{"
    local sep=""

    for _file in $(ls .methods/$METHOD/_params); do

        if ! $(is_in "$_file" "${ignored[@]}"); then
            local key=${_file%.txt}
            local pathvar=false
            
            local header=$(head -n 1 ".methods/$METHOD/_params/${_file}")

            if [[ $header == "__TYPE@PATHVAR__" ]]; then
                pathvar=true
                # removes the __TYPE@PATHVAR__ header
                tail -n +2 ".methods/$METHOD/_params/${_file}" > ".methods/$METHOD/_params/${_file}.tmp"
                mv ".methods/$METHOD/_params/${_file}.tmp" ".methods/$METHOD/_params/${_file}"

                header=$(head -n 1 ".methods/$METHOD/_params/${_file}")
            fi

			value=$(get_value $header $_file)
            
            if $pathvar; then
                url=$(set_url $value)

                sed -i "1s/^/__TYPE@PATHVAR__\n/" ".methods/$METHOD/_params/${_file}"
                # same as sed -1 "1__TYPE@PATHVAR__" ".methods/$METHOD/_params/${_file}"

            else
                _data="${_data}${sep} \"${key}\":\"${value}\""
                sep=","
            fi
        fi
    done

    data="$_data }"

    return 0
}

# TODO: Is this a bad solution?
parse_data

if [ -z $URL ]; then
    echo -e "\e[31;1mERROR:\e[0m No url provided."
    echo "Try ./manage.sh url <urlname> or ./manage.sh help for more information."
    exit 1
fi


if [ -z $VERBOSE -o $VERBOSE -eq 0 ]; then
    verbose=""

elif [ $VERBOSE -eq 1 ]; then
    verbose="-v"

else
    echo -e "\e[31;1mERROR:\e[0m No verbose provided."
    echo "Try ./manage.sh verbose <option> or ./manage.sh help for more information."
    exit 1
fi


if [ -z $HEADERS ]; then
    headers=""

else
    headers="-H '${HEADERS}'"
fi

data="-d '${data}'"

eval "curl $verbose -X ${METHOD^^} $url $headers $data"


#if [ $VERBOSE -eq 0 ]; then
#    curl -X ${METHOD^^} "$url" -H "$HEADERS" -d "$data"

#elif [ $VERBOSE -eq 1 ]; then
#    curl -v -X ${METHOD^^} "$url" -H "$HEADERS" -d "$data"
    # use -i for only body and header

#else
#    echo "ERROR: Unknown value for 'verbose' option."
#    echo "The value $VERBOSE is not known for the option 'verbose', ABORTING."
#    exit 1
#fi
