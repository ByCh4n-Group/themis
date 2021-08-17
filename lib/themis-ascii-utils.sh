#!/bin/bash

spintwo() {
    count=0
    total=34
    pstr="[=======================================================================]"
    
    [ -z $sleep ] && sleep="0.5" || sleep="$sleep"

    while [ $count -lt $total ]; do
    count=$(( $count + 2 ))
    pd=$(( $count * 73 / $total ))
    printf "\r%3d.%1d%% %.${pd}s" $(( $count * 100 / $total )) $(( ($count * 1000 / $total) % 100 )) $pstr
    sleep ${sleep} # this is the work
    done
}

error() {
    echo -e "\033[0;31m[-] Error Occured\033[0m: ${1}"
    case ${1} in
        1)
            return 1
        ;;
        2)
            exit 1
        ;;
    esac
}

warn() {
    echo -e "\033[0;33m[!] Warning\033[0m: ${1}."
}

info() {
    echo -e "\033[0;34m[*] Info\033[0m: ${1}."
}

success() {
    echo -e "\033[0;32m[+] Successfully\033[0m: ${1}."
}

found() {
    echo -e "\033[1;33m[\033[0;32m*\033[1;33m] Found!\033[0m: ${1}.."
}

notfound() {
    echo -e "\033[1;31m[-] Not Found!\033[0m: ${1}.."
    case ${1} in
        1)
            return 1
        ;;
        2)
            exit 1
        ;;
    esac
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
