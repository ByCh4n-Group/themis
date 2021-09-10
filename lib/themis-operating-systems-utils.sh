#!/bin/bash


checkroot() {
    if [[ ${EUID} != 0 ]] ; then
            echo -e "\033[0;31mpls try with root privalages 'sudo ${0}'\033[0m"
            checkroot="false"
            [[ ${1} =~ ^(exit|EXIT|--exit|--EXIT|-e)$ ]] && exit 1
        else
            echo -e "\033[0;32mset user have super cow powers....\033[0m"
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

update-os-catalogs() {
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
    if [ -e ~/.lastupdate.conf ] ; then
        source ~/.lastupdate.conf
        if [[ $(date +%Y%m%d) -gt $(( ${lastupdate} + 7 )) ]] ; then
            up
            echo "lastupdate='$(date +%Y%m%d)'" > ~/.lastupdate.conf
        else
            echo "Catalogs Are Up To Date."
        fi 
    else
        up
        echo "lastupdate='$(date +%Y%m%d)'" > ~/.lastupdate.conf
    fi
}

install-os-pkg() {
    updatecatalogs
    checkroot -e
    definebase
    case ${set_systembase} in
        debian)
            apt install -y ${1}
        ;;
        arch)
            pacman -Sy --noconfirm ${1}
        ;;
        fedora)
            dnf install -y ${1}
        ;;
        pisi)
            pisi it -y ${1}
        ;;
        opensuse)
            zypper remove --no-confirm ${1}
        ;;
    esac
}

uninstall-os-pkg() {
    checkroot -e
    definebase
    case ${set_systembase} in
        debian)
            apt remove -y ${1}
        ;;
        arch)
            pacman -R --noconfirm ${1}
        ;;
        fedora)
            dnf remove -y ${1}
        ;;
        pisi)
            pisirmt -y ${1}
        ;;
        opensuse)
            zypper remove --no-confirm ${1}
        ;;
    esac
}

check() {
    case ${1} in
        d)
            for check in $(seq 2 ${#}) ; do 
                [[ -d "${@:check:1}" ]] || { error "Directory ${@:check:1} not found!" ; checksign="bad" ; }
            done
        ;;
        f)
            for i in $(seq 2 ${#}) ; do 
                [[ -f "${@:check:1}" ]] || { error "File ${@:check:1} not found!" ; checksign="bad" ; }
            done
        ;;
        t)
            for i in $(seq 2 ${#}) ; do 
                [[ $(command -v ${@:check:1}) ]] || { error "Trigger ${@:check:1} not found! Please install that package." ; checksign="bad" ; }
            done
        ;;
        *)
            error "module ${0}: Called function ${FUNCNAME}: Wrong usage."
        ;;
    esac
    if [[ ${checksign} = "bad" ]] && [[ ${_checklevel} = "quit" ]] ; then
        exit 1
        _checklevel="optional"
    fi
}
