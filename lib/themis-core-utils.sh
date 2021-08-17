#!/bin/bash

__yesorno() {
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

__pressanykeysec() {
    # $1 int değer  inde bir sayı olmalıdır
    [ -z ${1} ] && pt="3" || pt="${1}"
    echo -n "pls wait (${pt}sec)..." ; read -t $pt -n 1 -r -s -p $'Or Press Any Key To Continue\n'
}

__pressanykey() {
    read -n 1 -r -s -p $'Press Any Key To Continue...\n'
}

__simtext() {
    yazi="${1}"
    [ -z ${sleep} ] && sleep="0.075" || sleep=${sleep}
    for ((i=0; i<${#yazi}; i++))
        do sleep $sleep
            printf "${yazi:$i:1}"
    done
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

bye() {
    __themis-tmp-manager stop
    __themis-pid_manager stop
    exit
}

check-all() {
    :
}
