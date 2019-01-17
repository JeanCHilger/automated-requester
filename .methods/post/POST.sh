#!/bin/bash

. .methods/post/.index.conf

ignored=($IGNORE_FILES)

is_in() {
    local target=$1; shift
    local arr=("$@")
    local in=0

    for i in "${arr[@]}"
        do
            if [[ $i == $target ]]; then
                in=1
                break
            fi
        done

    echo "$in"

    return 0
}

create_data() {
    # Assembles a JSON-like string variable with
    # keys being the name of the files found in /_params
    # and the values being random lines of this files.

    local data="{"
    local sep=""

    for file in $(ls .methods/post/_params)

        do
            local is=$(is_in "$file" "${ignored[@]}")

            if [ $is -eq 0 ]; then

                local key=${file%.txt}
                local header=$(head -n 1 ".methods/post/_params/${file}")

                if [[ $header == "__TYPE@RANDOMNUMBER__" ]]; then
                    local min=$(sed "2q;d" ".methods/post/_params/${file}")
                    local max=$(sed "3q;d" ".methods/post/_params/${file}")
                    local diff=$((max - min + 1))
                    local value=$(( ($RANDOM % diff) + min ))


                else
                    local n_of_lines=$(wc -l < ".methods/post/_params/${file}")
                    local f_line=$(( ($RANDOM % n_of_lines) + 1  ))
                    local value=$(sed "${f_line}q;d" ".methods/post/_params/${file}")
                fi

                data="${data}${sep} \"${key}\":\"${value}\""
                sep=","
            fi
        done

    echo "$data }"

    return 0
}

data=$(create_data)

if [ -z $URL ]; then
    echo "No url provided."
    echo "Try ./manage seturl <urlname> or ./manage help for more information."
    exit 1

elif [ -z $VERBOSE ]; then
    echo "No verbose provided."
    echo "Try ./manage setverbose <option> or ./manage help for more information."
    exit 1

elif [ -z $HEADERS ]; then
    echo "No header provided."
    echo "Try ./manage setheader <headerlist> or ./manage help for more information."
    exit 1

fi

if [ $VERBOSE -eq 0 ]; then
    curl -X POST "$URL" -H "$HEADERS" -d "$data"

elif [ $VERBOSE -eq 1 ]; then
    curl -v -X POST "$URL" -H "$HEADERS" -d "$data"

else
    echo "ERROR: Unknown value for 'verbose' option."
    echo "The value $VERBOSE is not known for the option 'verbose', ABORTING."
    exit 1
fi

