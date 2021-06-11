#!/bin/bash

checkroot() {
   reset='\033[0m'
   red='\033[0;31m'
   green='\033[0;32m'
    if [[ ${EUID} != 0 ]] ; then
            echo -e "${red}pls try with 'sudo ${0}'${reset}"
            checkroot="false"
            [[ ${1} =~ ^(exit|EXIT|--exit|--EXIT|-e)$ ]] && exit 1
        else
            echo -e "${green}set user have super powers....${reset}"
            checkroot="true"
    fi
}

definebase() {
    if [ -e ] ; then

    else
        set_systembase="unknow"
    fi
}

updatecatalogs() {
    up() {
        checkroot -e
        definebase
        case ${set_systembase} in

        esac
    }
    if [ -e /usr/share/themis/lastupdate.conf ] ; then
        source /usr/share/themis/lastupdate.conf
        if [[  ]] ; then

        fi 
    else
        up
        
    fi
}

installpkg() {
    updatecatalogs
    checkroot -e
    definebase
    case ${set_systembase} in

    esac

}