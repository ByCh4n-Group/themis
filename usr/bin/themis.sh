#!/bin/bash

#    themis the cross platform script management scripT
#    Copyright (C) 2021  lazypwny
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

# Göğsünde atınca senin mi sandın?

# major(1).minor(0).patch(0)
version="1"
maintainer="lazypwny"

## Configuration


setdir="$PWD"
user="${SUDO_USER:-$USER}"
group=$(cat /etc/group | awk -F: '{ print $1}' | grep -w ${user} || echo "users")

sethome="/usr/share/themis"
pkgmd="${sethome}/packages"

# Load Modules

loadmodules() {
    moduledir="${sethome}/modules"
    if [ -d ${moduledir} ] ; then
        for M in $(seq 1 ${#}) ; do
            if [ -e ${moduledir}/${@:M:1}.sh ] ; then
                source ${moduledir}/${@:M:1}.sh
            elif [ -e ${moduledir}/${@:M:1} ] ; then
                source ${moduledir}/${@:M:1}
            else
                echo "Module: ${@:M:1}.sh Can not Sourced!"
                exit 1
            fi
        done
    else
        echo "Your Module Directory Doesn't Exist! Check ${moduledir}"
        exit 1
    fi
}

# Call The Modules
loadmodules "color" "text-utils" "net-utils" "os-utils" "check" "spinners" "ascii-utils" "package-utils"

# Check
check-all

# main

case ${1} in
    [mM][aA][kK][eE][pP][aA][cC][kK][aA][gG][eE]|--[mM][aA][kK][eE][pP][aA][cC][kK][aA][gG][eE]|-[mM][pP])
        checkedepedns "tar"
        status="nice"
        if [ ${#} -gt 1 ] ; then
            for i in $(seq 2 ${#}) ; do
                if [ -d ${@:i:1} ] ; then
                    cd ${setdir}
                    makepackage "${@:i:1}"
                else
                    echo "'${@:i:1}' is not a directory please specify a directory."
                    status="bad"
                fi
            done
        else
            echo "please specify directory or directories of package(s)."
            exit 1
        fi
        [[ ${status} = "bad" ]] && { echo -e "${red}Some Package(s) Are Can Not Be Compiled!${reset}" ; exit 2 ; } || { [[ ${status} = "nice" ]]  && exit 0 || error "¿Unknow Error?" "e"; }
    ;;
    [lL][oO][cC][aA][lL][iI][nN][sS][tT][aA][lL][lL]|--[lL][oO][cC][aA][lL][iI][nN][sS][tT][aA][lL][lL]|-[lL][iI])
        [ -d ${pkgmd} ] || error "Packages Of MetaData Directory Not Found Please Check: ${pkgmd}" "e"
        checkedepedns "tar" "wget" "curl" "pip3" "gem"
        status="nice"
        checkroot -e
        if [ ${#} -gt 1 ] ; then
            for i in $(seq 2 ${#}) ; do
                if $(file ${@:i:1} | grep -q "gzip compressed data,") ; then
                    installpackage "${@:i:1}" "$(basename ${@:i:1})"
                else              # location        basename              
                    echo "${@:i:1}: that file isn't gzip comressed data please specify with name extension .tar.gz file(s)"
                    status="bad"
                fi
            done        
        else
            echo "please specify package or packages with name extension .tar.gz."
            exit 1
        fi
        [ -d /tmp/themis ] && rm -rf /tmp/themis
        [[ ${status} = "bad" ]] && { echo -e "${red}Some Package(s) Are Can Not Be Installed!${reset}" ; exit 2 ; } || { [[ ${status} = "nice" ]]  && exit 0 || error "¿Unknow Error?" "e"; }
    ;;
    *)
        echo -e "${blue}"
        ascii-art "elephant"
        echo -e "${Bred}Wrong usage there are two(2) flags${reset}: --makepackage, --localinstall"
        randomexitmessage
        exit 1
    ;;
esac