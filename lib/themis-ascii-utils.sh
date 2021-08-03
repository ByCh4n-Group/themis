	#!/bin/bash

yesorno() {
    read -r -p "are you sure you want to continue? [Y/n] " response
    case "$response" in
        [nN]) 
            if [[ ${2} = "" ]] ; then
                Yesorno="false"
                echo "Aborted"
            else
                ${2}
            fi
            ;;
        *)
            if [[ ${1} = "" ]] ; then
                Yesorno="true"
            else
                ${1}
            fi
            ;;
    esac
}

pressanykeysec() {
    # $1 int değer  inde bir sayı olmalıdır
    [ -z ${1} ] && pt="3" || pt="${1}"
    echo -n "pls wait (${pt}sec)..." ; read -t $pt -n 1 -r -s -p $'Or Press Any Key To Continue\n'
}

pressanykey() {
    read -n 1 -r -s -p $'Press Any Key To Continue...\n'
}

centexpad() {
    termwidth="$(tput cols)"
    [ -z ${setchar} ] && setchar="=" || setchar="$setchar"
    padding="$(printf '%0.1s' ${setchar}{1..500})"
    printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}

centex() {
    COLUMNS=$(tput cols)
    title=$1
    printf "%*s\n" $(((${#title}+$COLUMNS)/2)) "$title"
}

simtext() {
    yazi="${1}"
    [ -z ${sleep} ] && sleep="0.075" || sleep=${sleep}
    for ((i=0; i<${#yazi}; i++))
        do sleep $sleep
            printf "${yazi:$i:1}"
    done
}
