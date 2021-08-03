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

getlib() {
    if [[ -d ${themis_libs} ]] ; then
        for M in $(seq 1 ${#}) ; do
            if [[ -e ${themis_libs}/${@:M:1}.sh ]] ; then
                source ${themis_libs}/${@:M:1}.sh
            elif [[ -e ${themis_libs}/${@:M:1} ]] ; then
                source ${themis_libs}/${@:M:1}
            else
                echo -e "\033[0;31mFatal: Library ${@:M:1}.sh Couldn't Sourced!\033[0m"
                exit 1
            fi
        done
    else
        echo -e "\033[0;31mThe Library Directory Doesn't Exist! Please Reinstall the Tool.\033[0m"
        exit 1
    fi
}

getlib "themis-colors" "themis-ascii-utils" "themis-operating-systems-utils" "themis-network-utils" "themis-utils"

check-all

case ${1} in
    [hH][eE][lL][pP]|--[hH][eE][lL][pP]|-[hH])
        echo -e "There are X flag(s):
--

--

--
"
    exit 0
    ;;
    [vV][eE][rR][sS][iI][oO][nN]|--[vV][eE][rR][sS][iI][oO][nN]|-[vV])
        echo "$(basename ${0}) ${version} by ${maintainer} - 2021"
        exit 0
    ;;
    [mM][aA][kK][eE][pP][aA][cC][kK][aA][gG][eE]|--[mM][aA][kK][eE][pP][aA][cC][kK][aA][gG][eE]|-[mM][pP])
        getlib "themis-dev-utils"
        makepackage "${@:2}"
        exit 0
    ;;
    [lL][oO][cC][aA][lL][iI][nN][sS][tT][aA][lL][lL]|--[lL][oO][cC][aA][lL][iI][nN][sS][tT][aA][lL][lL]|-[lL][iI])
        if [[ ! -f ${themis_lock} ]] ; then 
            themis-lock-daemon lock
            getlib "themis-package-utils"
            themis-lock-daemon unlock
            exit 0
        else
            error "Themis has been locked from another process. If you think this is a mistake delete the ${themis_lock} file"
        fi
    ;;
    *)
        echo -e "'${1}$([[ -z ${1} ]] && echo " ")' is Unknow Option: Type '$(basename ${0}) --help' to see the arguments you can type."
        bye
    ;;
esac