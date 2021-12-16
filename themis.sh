#!/bin/bash

#    simple package manager written in bash - themis
#    Copyright (C) 2021  lazypwny751
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Kalp Allah'ın mülküdür. Göğsünde atınca senin mi sandın?

. /usr/share/themis/themis.conf || { echo -e "\033[0;31mFatal: Options File Couldn't Sourced!\033[0m" ; exit 1 ; }

getlib "colorsh" "themis-operating-systems-utils" "themis-core-utils"

check-all

trap bye INT 

case ${1} in
    [hH][eE][lL][pP]|--[hH][eE][lL][pP]|-[hH])
        echo -e "There are X flag(s): --version, --makepackage, --sign, --localinstall
--makepackage | makepackage | -mp:
    You can create your own cross packages of scripts or programs.

--sign | sign | -sn:
    Sign your own packages against theft.

--localinstall | localinstall | -li:
    Install packages from your file system.

--install | install | -i:
    Install your packages from repository easly.

--uninstall | uninstall | -u:
    Un-Install your packages from your computer.

--makerepo | makerepo | -mr:
    Build your own repositiries.

--list | list | -l:
    List your installed/can be install/in repositories packages.
  
--version | version | -v:
    Shows current version of ${BASH_SOURCE[0]}.
"
    exit 0
    ;;
    [vV][eE][rR][sS][iI][oO][nN]|--[vV][eE][rR][sS][iI][oO][nN]|-[vV])
        echo "$(basename ${0}) ${version} by ${maintainer} - 2021"
        exit 0
    ;;
    [mM][aA][kK][eE][pP][aA][cC][kK][aA][gG][eE]|--[mM][aA][kK][eE][pP][aA][cC][kK][aA][gG][eE]|-[mM][pP])
        getlib "themis-dev-utils"
        __makepackage ${@:2}
        exit 0
    ;;
    [sS][iI][gG][nN]|--[sS][iI][gG][nN]|-[sS][nN])
        # also you can sign another type files with this argument
        getlib "opnsslkm"
        if [[ ${#} -ge 2 ]] ; then
            for i in $(seq 2 ${#}) ; do
                if [[ -f "${@:i:1}" ]] ; then
                    __sif "${@:i:1}" && success "one file has signed."
                else
                    error "what does 2 + 2 = ¿¿"
                fi
            done
        else
            error "Please give me some package/s for signing (*-*)." "2"
        fi
    ;;
    [iI][nN][sS][tT][aA][lL][lL]|--[iI][nN][sS][tT][aA][lL][lL]|-[iI])
        checkroot -e # root kontrol
        if [[ ! -f ${themis_lock} ]] ; then
            __themis-pid_manager start || error "manager(s) can not be executing in this time" "2"
            getlib "themis-package-utils"
            #__install ${@:2} # aslı bu olmak şekilde
            __installpackage "${@:2}"
            __themis-tmp-manager stop
        else
            . ${themis_temp}/themis.pid
            error "Themis is already running on pid '${themis_pid}'. If you think it's a mistake you can delete the '${themis_temp}/themis.pid' file" "2"
        fi
        bye 0
    ;;
    [uU][nN][iI][nN][sS][tT][aA][lL][lL]|--[uU][nN][iI][nN][sS][tT][aA][lL][lL]|-[uU])
        checkroot -e # root kontrol
        if [[ ! -f ${themis_lock} ]] ; then
            __themis-pid_manager start || error "manager(s) can not be executing in this time" "2"
            getlib "themis-package-utils"
            __uninstall ${@:2}
            __themis-tmp-manager stop
        else
            source ${themis_temp}/themis.pid
            error "Themis is already running on pid '${themis_pid}'. If you think it's a mistake you can delete the '${themis_temp}/themis.pid' file" "2"
        fi
        bye 0
    ;;
    [mM][aA][kK][eE][rR][eE][pP][oO]|--[mM][aA][kK][eE][rR][eE][pP][oO]|-[mM][rR])
        getlib "themis-dev-utils"
        [[ ${2} = [sS][iI][gG][nN] ]] && __signlevel="true"
        __makerepo "${__signlevel}" && success "The repositoriy created." || error "The repository couldn't creating in this time¿" "2"
    ;;
    [uU][pP][dD][aA][tT][eE]|--[uU][pP][dD][aA][tT][eE]|-[uU][pP])
        getlib "themis-network-utils"
        __update_themis_catalogs
    ;;
    [lL][iI][sS][tT]|--[lL][iI][sS][tT]|-[lL])
        getlib "sqlit3"
        _req4sl3
        case "${2}" in
            ""|" ")
                sqlite3 "${themis_db}" "SELECT pkg, ver FROM packages"
            ;;
            -[pP])
                sqlite3 "${themis_db}" "SELECT pkg FROM packages"
            ;;
            [rR][eE][pP][oO])
                echo "comming soon"
            ;;
            *)
                sqlite3 "${themis_db}" "SELECT pkg, ver, maintainer, desc FROM packages WHERE pkg LIKE '${2}'"
            ;;
        esac
    ;;
    *)
        echo -e "'${1}$([[ -z ${1} ]] && echo " ")' is an unknown option. Type to see the guide '$(basename ${0}) --help'"
        exit 0
    ;;
esac