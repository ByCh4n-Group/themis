#!/bin/bash

#    aur package builder for PnmOS - PNM
#    Copyright (C) 2021  suleymanfatih
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

## conf

aur="https://aur.archlinux.org"
savedir="~/Documents/github/gitpnmos/workstation/sshpnmrepository/derlenmişdosyalar"
workdir="${HOME}/.pnmsources"
searcherr="hata: hedef bulunamadı:"

## f(x)

__depcheck() {
    for _dcx in $(seq 1 ${#}) ; do
        [[ $(command -v ${@:_dcx:1}) ]] || { echo "${@:_dcx:1} not found please install it." ; _dcx_status="1" ; }
    done

    if [[ ${_dcx_status} = "1" ]] ; then
        echo "Some dependecies not found!"
        exit 1
    fi
}

## main()

# before start
__depcheck "git" "makepkg" "gzip"
[[ -d "${workdir}" ]] || mkdir -p "${workdir}"
[[ -d "${savedir}" ]] || mkdir -p "${savedir}"

# main
for i in $(seq 1 ${#}) ; do
    cd "${workdir}"
    git clone "${aur}/${@:i:1}.git"
    step1="$?"
    if [[ ${step1} = "0" ]] ; then
        cd "${workdir}/${@:i:1}"
        makepkg -si 2> error-output.txt
        step2="$?"
        if [[ ${step2} = "0" ]] ; then
            if [[ -e "${@:i:1}-*.pkg.tar.zst" ]] ; then 
                mv "$(ls ${@:i:1}-*.pkg.tar.zst)" "${savedir}" 
            elif [[ -e "${@:i:1}-*.pkg.tar.xz" ]] ; then
                mv "$(ls ${@:i:1}-*.pkg.tar.xz)" "${savedir}" 
            else
                echo -e "\033[4;31mThe binary of '${@:i:1}' not found!\033[0m"
            fi
        elif [[ ${step2} = "8" ]] && [[ -e ./error-output.txt ]] ; then
            if [[ $(cat ./error-output.txt | grep "${searcherr}" | awk '{print $NF}') != "" ]] ; then
                cat ./error-output.txt | grep "${searcherr}" | awk '{print $NF}' > missing-packages.list
                for x in $(seq 1 $(wc -l ./missing-packages.list | awk '{print $1}')) ; do
                    depf="$(cat ./missing-packages.list | awk NR==$x)"
                    git clone "${aur}/${depf}.git"
                    step3="$?"
                    fi [[ ${step3} = "0" ]] ; then
                        cd "${depf}"
                        makepkg -si
                        step4="$?"
                        if [[ ${step4} = "0" ]] ; then
                            if [[ -e ${depf}-*.pkg.tar.zst ]] ; then
                                mv ${depf}-*.pkg.tar.zst "${savedir}"
                            elif [[ -e ${depf}-*.pkg.tar.xz ]] ; then
                                mv ${depf}-*.pkg.tar.xz "${savedir}"
                            else
                                echo -e "\033[4;31mDependencity of '${@:i:1}' the '${depf}'s binary not found?!\033[0m"
                            fi
                        else
                            echo -e "\033[4;31mWhat? Again.. No i can't take more do it yourself(!)\033[0m"
                        fi
                    else
                        echo -e "\033[4;31mDependencity of '${@:i:1}' the '${depf}' is not in '${aur}'\033[0m"
                    fi
                done
            else
                echo -e "\033[4;31mThe error output log found but no dependencies detected.\033[0m"
            fi
        else
            echo -e "\033[4;31mError occured while building the package!\033[0m"
        fi
    else
        echo -e "\033[4;31mError occured while downloading the '${@:i:1}'.\n\t1. Do you have internet?\n\t2. Is this repository exist?\n\t3. Are you sure the repository name is spelled correctly?\033[0m"
    fi
done