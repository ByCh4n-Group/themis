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

themis-ascii-magic() {
    case ${1} in
        a)
        ;;
        b)
        ;;
        c)
        ;;
        d)
        ;;
        *)
        ;; 
    esac
}

themis-randendmsg() {
    case $(( $RANDOM % 4 )) in
        0)
            echo ""
        ;;
        1)
            echo ""
        ;;
        2)
            echo ""
        ;;
        3)
            echo ""
        ;;
        4)
            echo ""
        ;;
        *)
            echo ""
        ;;
    esac
}

themis-tmp-manager() {
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

themis-lock-daemon() {
    case ${1} in
        lock)
            touch ${themis_lock}
        ;;
        unlock)
            [[ -f ${themis_lock} ]] && rm ${themis_lock}
        ;;
    esac
}

bye() {
    themis-tmp-manager stop
    themis-lock-daemon unlock   
    exit
}

check-all() {
    :
}