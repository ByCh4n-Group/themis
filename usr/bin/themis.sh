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

# Kalp Allah'ın mülküdür. Göğsünde atınca senin mi sandın?

# major(1).minor(0).patch(0)
version="1"
maintainer="lazypwny"

## Configuration

setdir="$PWD"
user="${SUDO_USER:-$USER}"
group=$(cat /etc/group | awk -F: '{ print $1}' | grep -w ${user} || echo "users")

sethome="/usr/share/themis"
pkgmd="${sethome}/packages"
repodir="${sethome}/repositories"

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
loadmodules "color" "text-utils" "net-utils" "os-utils" "check" "spinners" "ascii-utils" "package-utils" "repository-utils"

# Check
check-all

# main

case ${1} in
    [mM][aA][kK][eE][pP][aA][cC][kK][aA][gG][eE]|--[mM][aA][kK][eE][pP][aA][cC][kK][aA][gG][eE]|-[mM][pP])
        checkdepedns "tar"
        status="nice"
        if [ ${#} -gt 1 ] ; then
            for i in $(seq 2 ${#}) ; do
                if [ -d "${@:i:1}" ] ; then
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
        exit 0
    ;;
    [lL][oO][cC][aA][lL][iI][nN][sS][tT][aA][lL][lL]|--[lL][oO][cC][aA][lL][iI][nN][sS][tT][aA][lL][lL]|-[lL][iI])
        [ -d ${pkgmd} ] || error "Packages Of MetaData Directory Not Found Please Check: ${pkgmd}" "e"
        checkdepedns "tar" "wget" "curl" "pip3" "gem"
        status="nice"
        checkroot -e
        if [ ${#} -gt 1 ] ; then
            for i in $(seq 2 ${#}) ; do
                cd ${setdir}
                if $(file "${@:i:1}" | grep -q "gzip compressed data,") ; then
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
        exit 0
    ;;
    [uU][nN][iI][nN][sS][tT][aA][lL][lL]|--[uU][nN][iI][nN][sS][tT][aA][lL][lL]|-[uU])
        [ -d ${pkgmd} ] || error "Packages Of MetaData Directory Not Found Please Check: ${pkgmd}" "e"
        status="nice"
        checkroot -e
        if [[ ${#} -gt 1 ]] ; then
            for i in $(seq 2 ${#}) ; do
                if [ -d "${pkgmd}/${@:i:1}" ] ; then
                    uninstallpackage "${pkgmd}/${@:i:1}"
                else
                    error "${@:i:1}: that package is not installed"
                    status="bad"
                fi
            done
        else
            echo "please specify package name(s) for uninstall."
            exit 1
        fi
        [[ ${status} = "bad" ]] && { echo -e "${red}Some Package(s) Are Can Not Be Removed!${reset}" ; exit 2 ; } || { [[ ${status} = "nice" ]]  && exit 0 || error "¿Unknow Error?" "e"; }
        exit 0
    ;;
    [uU][pP][dD][aA][tT][eE][iI][nN][eE][xX]|--[uU][pP][dD][aA][tT][eE][iI][nN][eE][xX]|-[uU][pP])
        [ -d ${repodir} ] || error "repositories configuration directory doesn't exist please check it: ${repodir}" "e"
        checkdepedns "wget" "ping" "sha256sum"
        [[ -e "${sethome}/index.sh" ]] && source "${sethome}/index.sh" || error "repositories configuration file not found please check it: ${sethome}/index.sh" "e"
        checkroot -e
        status="nice"
        if [[ ! -z ${#repositories[@]} ]] ; then
            for i in $(seq 0 $((${#repositories[@]} - 1)) ) ; do
                updateindex "${repositories[i]}"
            done
        else 
            error "variable repositories can not be null in index.sh file" "e"
        fi
        [[ ${status} = "bad" ]] && { echo -e "${red}metadata information of some repositories could not be retrieved this may cause problems in the future!${reset}" ; exit 2 ; } || { [[ ${status} = "nice" ]]  && exit 0 || error "¿Unknow Error?" "e"; }
        exit 0
    ;;
    [lL][iI][sS][tT]|--[lL][iI][sS][tT]|-[lL])
        case ${2} in
            [rR][eE][pP][oO][sS][iI][tT][oO][iI][eE][sS]|--[rR][eE][pP][oO][sS][iI][tT][oO][iI][eE][sS]|[rR][eE][pP][oO])
                [ -d ${repodir} ] || error "Repositories MetaData Directory Not Found Please Check it: ${repodir}" "e"
                status="nice"
                echo -e "${Bpurple}"
                ascii-art "anime-girl"
                echo -e "${reset}"
                for i in $(seq 1 $(ls ${repodir} | wc -l)) ; do
                    repostatus="nice"
                    setrepomdir=$(ls ${repodir} | awk NR==$i'{print $1}')
                    if [[ -e "${setrepomdir}/index.sh" ]] ; then
                        maintainer=""
                        reponame=""
                        packages=""
                        source "${setrepomdir}/index.sh"
                        [ -z ${maintainer} ] && maintainer="anyone"
                        [ -z ${reponame} ] && repostatus="bad"
                        [[ -z ${#packages[@]} ]] && repostatus="bad"
                        if [[ ${repostatus} = "nice" ]] ; then
                            
                        elif [[ ${repostatus} = "bad" ]] ; then
                            error "${setrepomdir} has bad configured"
                            status="bad"
                        fi
                    else
                        error "repository ${setrepomdir} has bad configured"
                        status="bad"
                    fi
                done
            ;;
                [[ ${status} = "bad" ]] && { echo -e "${red}you have broken repository or repositories!${reset}" ; exit 2 ; } || { [[ ${status} = "nice" ]]  && exit 0 || error "¿Unknow Error?" "e"; }
            *)
                [ -d ${pkgmd} ] || error "Packages Of MetaData Directory Not Found Please Check it: ${pkgmd}" "e"
                echo -e "${Bgrey}"
                ascii-art "casper"
                echo -e "${Bwhite}Package(s)${reset}:\n${Bblue}$(ls ${pkgmd} && { [ $(ls ${pkgmd} | wc -l) = 0 ] && echo "this place looks pretty deserted don't forget to check out our gitpage to check out the new packages" ; })${reset}\n${Bwhite}Total package(s)${reset}: ${Bred}$(ls ${pkgmd} | wc -l)${reset}"
                [ $(ls ${pkgmd} | wc -l) != 0 ] && echo "these packages are prepared in accordance with the procedure of themis project - ${maintainer} $(basename ${0}) Version ${version}"
            ;;
        esac
        randomexitmessage
        exit 0
    ;;
    [iI][nN][fF][oO]|--[iI][nN][fF][oO]|-[iI])
        [ -d ${pkgmd} ] || error "Packages Of MetaData Directory Not Found Please Check: ${pkgmd}" "e"
        status="nice"
        if [[ ${#} -gt 1 ]] ; then
            for i in $(seq 2 ${#}) ; do
                setchar=""
                if [ -e "${pkgmd}/${@:i:1}/CONTROL" ] ; then
                    centexpad "i"
                    package=""
                    version=""
                    maintainer=""
                    description=""
                    source "${pkgmd}/${@:i:1}/CONTROL"
                    if [[ ! -z ${package} ]] ;  then
                        [[ -z ${version} ]] && version="1.0.0"
                        [[ -z ${maintainer} ]] && maintainer="anyone"
                        [[ -z ${description} ]] && description="rtfm"
                        echo "${maintainer} thanks you for use ${package} Version ${version}"
                        echo -e "\n${Bblue}package${reset}: ${Bwhite}${package}${reset}\n${Bblue}version${reset}: ${Bwhite}${version}${reset}\n${Bblue}maintainer${reset}: ${Bwhite}${maintainer}${reset}\n${Bblue}description${reset}: ${Bwhite}${description}${reset}"
                        
                        if [ -e ${pkgmd}/${@:i:1}/README.* ] ; then
                            setchar="-"
                            centexpad "README File(s)"
                            cat ${pkgmd}/${@:i:1}/README.*
                            centexpad "README"
                            echo -e "${reset}"
                        fi
                        
                        if [[ -e "${pkgmd}/${@:i:1}/LICENSE" ]] ; then
                            setchar="-"
                            centexpad "LICENSE - First 10 line"
                            head -n 10 "${pkgmd}/${@:i:1}/LICENSE"
                            centexpad "LICENSE"
                            echo -e "${reset}"
                        fi
                    else
                        echo "¿taşşaq mi geçiyorsun canim?"
                        status="0"
                    fi
                    setchar=""
                    centexpad "i"
                    echo -e "${reset}"
                else
                    error "${@:i:1}: doesn't exist"
                    status="bad"
                fi
            done
        else
            echo "please specify package name(s)."
            exit 1
        fi
        [[ ${status} = "bad" ]] && { echo -e "${red}Some Package(s) Are Can Not Sourced!${reset}" ; exit 2 ; } || { [[ ${status} = "nice" ]]  && exit 0 || error "¿Unknow Error?" "e"; }
        exit 0
    ;;
    [vV][eE][rR][sS][iI][oO][nN]|--[vV][eE][rR][sS][iI][oO][nN]|-[vV])
        echo -e "${maintainer} $(basename ${0}) Version ${version}\n\nteam: https://github.com/ByCh4n-Group\nsource: https://github.com/ByCh4n-Group/themis\ncontact: https://discord.com/invite/dQbvahVVG4"
        exit 0
    ;;
    *)
        echo -e "${blue}"
        ascii-art "elephant"
        echo -e "${Bred}Wrong usage there are seven(7) flags${reset}: --makepackage, --localinstall, --uninstall, --updateindex, --list, --info, --version"
        randomexitmessage
        exit 1
    ;;
esac