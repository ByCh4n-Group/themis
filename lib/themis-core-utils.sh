#!/bin/bash

__yesorno() {
    read -r -p "are you sure you want to continue? [Y/n] " response
    case "$response" in
        [nN]) 
            if [[ ${2} = "" ]] ; then
                yesorno="false"
                echo "Aborted"
            else
                ${2}
            fi
            ;;
        *)
            if [[ ${1} = "" ]] ; then
                yesorno="true"
            else
                ${1}
            fi
            ;;
    esac
}

__pressanykeysec() {
    # $1 int değer  inde bir sayı olmalıdır
    [ -z ${1} ] && pt="3" || pt="${1}"
    echo -n "pls wait (${pt}sec)..." ; read -t $pt -n 1 -r -s -p $'Or Press Any Key To Continue\n'
}

__pressanykey() {
    read -n 1 -r -s -p $'Press Any Key To Continue...\n'
}

__themis-tmp-manager() {
    case ${1} in
        start)
            [[ -d ${themis_temp} ]] || mkdir -p ${themis_temp} 2> /dev/null
        ;;
        stop)
            [[ -d ${themis_temp} ]] && rm -rf ${themis_temp} 2> /dev/null
        ;;
        restart)
            [[ -d ${themis_temp} ]] && rm -rf ${themis_temp} 2> /dev/null
            mkdir -p ${themis_temp}
        ;;
    esac
}

__themis-pid_manager() {
    case ${1} in
        start)
            __themis-tmp-manager start
            echo "themis_pid='${BASHPID}'" > ${themis_lock} 
        ;;
        stop)
            [[ -f ${themis_temp}/themis.pid ]] && rm ${themis_lock}
        ;;
        restart)
            [[ -f ${themis_temp}/themis.pid ]] && rm ${themis_lock}
            __themis-tmp-manager start && echo "themis_pid='${BASHPID}'" > ${themis_lock}
        ;;
    esac
}

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
    case "${2}" in
        1)
            return 1
        ;;
        2)
            __themis-tmp-manager stop
            exit 1
        ;;
        *)
            :
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
    case "${2}" in
        1)
            return 1
        ;;
        2)
            __themis-tmp-manager stop
            exit 1
        ;;
        *)
            :
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

simtext() {
    yazi="${1}"
    [ -z ${sleep} ] && sleep="0.075" || sleep=${sleep}
    for ((i=0; i<${#yazi}; i++))
        do sleep $sleep
            printf "${yazi:$i:1}"
    done
}


bye() {
    __themis-tmp-manager stop
    exit "${1}"
}

check-all() {
    :
}

fixit() {
    # all lower case for first arguments
    case "${1}" in
        database|--database|-db)
            [[ -f ${themis_pkgs} ]] || sqlite3 "${themis_pkgs}" "CREATE TABLE packages(pkg TEXT,ver TEXT,maintainer TEXT,desc TEXT,codec TEXT)"
        ;;
        pubkey|--pubkey|-pk)
            if [[ ! -f "${themis_home}/pub.pem" ]] ; then
                checkroot -e
                [[ ! -f "${themis_home}/priv.pem" ]] && openssl genrsa -out "${themis_home}/priv.pem" 2048 
                openssl rsa -in "${themis_home}/priv.pem" -outform PEM -pubout -out "${themis_home}/pub.pem"
            fi
        ;;
    esac
}

# always in develop
#  Themis'in en en en kanser kütüphanesi