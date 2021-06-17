#!/bin/bash

checkroot() {
   reset='\033[0m'
   red='\033[0;31m'
   green='\033[0;32m'
    if [[ ${EUID} != 0 ]] ; then
            echo -e "${red}pls try with root privalages 'sudo ${0}'${reset}"
            checkroot="false"
            [[ ${1} =~ ^(exit|EXIT|--exit|--EXIT|-e)$ ]] && exit 1
        else
            echo -e "${green}set user have super cow powers....${reset}"
            checkroot="true"
    fi
}

definebase() {
    if [ -e /etc/debian_version ] ; then
        set_systembase="debian"
    elif [ -e /etc/arch-release ] ; then
        set_systembase="arch"
    elif [ -e /etc/artix-release ] ; then
        set_systembase="arch"
    elif [ -e /etc/fedora-release ] ; then
        set_systembase="fedora"
    elif [ -e /etc/pisi-release ] ; then
        set_systembase="pisi"
    elif [ -e /etc/zypp/zypper.conf ] ; then
        set_systembase="opensuse"
    else
        set_systembase="unknow"
    fi
}

updatecatalogs() {
    up() {
        checkroot -e
        netcheck "e"
        definebase
        case ${set_systembase} in
            debian)
                apt update
            ;;
            arch)
                pacman -Syyy
            ;;
            fedora)
                dnf check-update
            ;;
            pisi)
                pisi ur
            ;;
            opensuse)
                zypper refresh
            ;;
        esac
    }
    if [ -e /usr/share/themis/lastupdate.conf ] ; then
        source /usr/share/themis/lastupdate.conf
        if [[ $(date +%Y%m%d) -gt $(( ${lastupdate} + 7 )) ]] ; then
            up
            echo "lastupdate='$(date +%Y%m%d)'" > /usr/share/themis/lastupdate.conf
        else
            echo "Catalogs Are Up To Date."
        fi 
    else
        up
        echo "lastupdate='$(date +%Y%m%d)'" > /usr/share/themis/lastupdate.conf
    fi
}

installpkg() {
    updatecatalogs
    checkroot -e
    netcheck "e"
    definebase
    case ${set_systembase} in
        debian)
            apt install -y "${1}"
        ;;
        arch)
            pacman -Sy --noconfirm "${1}"
        ;;
        fedora)
            dnf install -y "${1}"
        ;;
        pisi)
            pisi it -y "${1}"
        ;;
        opensuse)
            zypper install --no-confirm "${1}"
        ;;
    esac

}