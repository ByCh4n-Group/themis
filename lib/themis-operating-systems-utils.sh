#!/bin/bash

checkroot() {
    if [[ ${EUID} != 0 ]] ; then
            echo -e "\033[0;31mpls try with root privalages 'sudo ${0}'\033[0m" # standart error output
            checkroot="false" # variable for user to be use
            [[ ${1} =~ ^(exit|EXIT|--exit|--EXIT|-e)$ ]] && { __themis-tmp-manager stop ; exit 1 ; } # or direct quit
        else
            echo -e "\033[0;32mset user have super cow powers....\033[0m" # standart output
            checkroot="true" # variable for user to be use
    fi
}

definebase() {
    if [[ -e /etc/debian_version ]] ; then
        set_systembase="debian"
    elif [[ -e /etc/arch-release ]] ; then
        set_systembase="arch"
    elif [[ -e /etc/artix-release ]] ; then
        set_systembase="arch"
    elif [[ -e /etc/fedora-release ]] ; then
        set_systembase="fedora"
    elif [[ -e /etc/pisi-release ]] ; then
        set_systembase="pisi"
    elif [[ -e /etc/zypp/zypper.conf ]] ; then
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
    update-os-catalogs
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

__is_arch() {
    case "${1}" in
        [xX]86)
            if [[ $(uname -i) = "x86" ]] ; then
                return 0
            else
                return 1
            fi
        ;;
        [xX]64|[xX]86_[xX]64)
            if [[ $(uname -i) = "x86_64" ]] ; then
                return 0
            else
                return 1
            fi
        ;;
        [aA][aA][rR][cC][hH]64)
            if [[ $(uname -i) = "aarch64" ]] ; then
                return 0
            else
                return 1
            fi
        ;;
        *)
            echo "unknow architecture."
            # So script then +
            return 0
        ;;
    esac
}

check() {
    case ${1} in
        d)
            for check in $(seq 2 ${#}) ; do 
                [[ -d "${@:check:1}" ]] || { tos_chk="false" ; error "Directory ${@:check:1} not found!" ; }
            done
        ;;
        f)
            for i in $(seq 2 ${#}) ; do 
                [[ -f "${@:check:1}" ]] || { error "File ${@:check:1} not found!" ; }
            done
        ;;
        t)
            for i in $(seq 2 ${#}) ; do 
                [[ $(command -v ${@:check:1}) ]] || { error "Trigger ${@:check:1} not found! Please install that package." ; }
            done
        ;;
        *)
            error "module ${0}: Called function ${FUNCNAME}: Wrong usage."
        ;;
    esac

    if [[ ${tos_chk} = "false" ]] ; then
        if [[ ${tos_check_opt} = "none" ]] ; then
            :
        elif [[ ${tos_check_opt} = "return" ]] ; then
            tos_check_opt="none"
            return 1
        elif [[ ${tos_check_opt} = "exit" ]] ; then
            tos_check_opt="none" # ther are no export but idk why i put this
            exit 1
        fi
    fi
}

# lazypwny751 - 10-09-2021
# Themis'in en kanser kütüphanesi
