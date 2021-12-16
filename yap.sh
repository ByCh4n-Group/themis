#!/bin/bash


#    sub-industry make for themis - yap.sh
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

# Ayıbın büyüğü, aynısı sende varken başkasını ayıplamandır. - Hz. Ali (r.a.)


package="yap"
version="1.0.0"
maintainer="lazypwny"

# teker teker debug için de birebir çözüm olabilir. [TR]
# set -e # log olayından dolayı bu arkadaşı kullanmamanızı öneririm lakin

# $yapX = satır (current line)

__flat() {
    # Make'in alt fonksiyonu
    # kurma
    post() {
        [[ ${d_mod} = "755" ]] && d_mod="${d_mod}" || d_mod="755"
        if [[ -f ./"${1}" ]] && [[ -d /"${2}" ]] ; then
            install -m "${d_mod}" ./"${1}" /"${2}" && echo -e "-rwxr-xr-x \033[0;32m$(realpath ${2}/${1})\033[0m" || return 1
            d_mod="755"
        else
            echo "line ${yapX}: ${FUNCNAME[0]}: insufficient or wrong usage parametre!"
            d_mod="755"
            return 1
        fi
    }

    copy() {
        case ${1} in
            --[dD][iI][rR][eE][cC][tT][oO][rR][yY]|-[dD][iI][rR])
                if [[ -d ./"${2}" ]] && [[ -d /"${3}" ]] ; then
                    cp -r ./"${2}" /"${3}" && echo "put $(realpath ${3}/${2})" || return 1
                else
                    echo "line ${yapX}: ${FUNCNAME[0]}: insufficient or wrong usage parametre!"
                    return 1
                fi
            ;;
            *)
                if [[ -f ./"${1}" ]] && [[ -d /"${2}" ]] ; then
                    cp ./"${1}" /"${2}" && echo "put $(realpath ${2}/${1})" || return 1
                else
                    echo "line ${yapX}: ${FUNCNAME[0]}: insufficient or wrong usage parametre!"
                    return 1
                fi
            ;;
        esac
    }

    ## get() {
        # checknet
        # if check arguments&parametres
        ##:
        # get the file just in pwd
    ## }
}

__reverse() {
    # Make'in alt fonksiyonu
    # kaldırma
    post() {
        if [[ -f /"${2}/${1}" ]] ; then
            rm -f /"${2}/${1}" && echo -e "\033[0;31m${1}\033[0m -> \033[0;31m/dev/null\033[0m" || return 1
        else
            echo "line ${yapX}: ${FUNCNAME[0]}: the file ${1} is already removed or not installed yet!"
        fi
    }

    copy() {
        case ${1} in
            --[dD][iI][rR][eE][cC][tT][oO][rR][yY]|-[dD][iI][rR])
                if [[ -d "${3}/${2}" ]] ; then
                    rm -rf /"${3}"/"${2}" && echo -e "\033[0;31m${3}/${2}\033[0m -> \033[0;31m/dev/null\033[0m"
                else
            echo "line ${yapX}: ${FUNCNAME[0]}: the directory ${2} is already removed or not installed yet!"
                fi
            ;;
            *)
                if [[ -f /"${2}"/"${1}" ]] ; then
                    rm -f /"${2}"/"${1}" && echo -e "\033[0;31m${1}\033[0m -> \033[0;31m/dev/null\033[0m"
                else
                    echo "line ${yapX}: ${FUNCNAME[0]}: the file ${1} is already removed or not installed yet!"
                fi
            ;;
        esac
    }
}

# yap dosyası burada olsaydı nasıl olurdu:
setyapf="$(ls ./[yY][aA][pP][fF][iI][lL][eE] | awk 'NR==1')"

__make() {
    # load flat or reverse
    case "${1}" in
        [rR][eE][vV][eE][rR][sS][eE])
            # revers'i çağır
            __reverse
        ;;
        [fF][lL][aA][tT])
            # flat'ı çağır
            __flat
        ;;
        *)
            echo "can not load the module: ${FUNCNAME}"
            return 1
        ;;
    esac

    # bu bir yap projesi mi?
    if [ -f ./"${setyapf}" ] ; then
        # hm tamam madem yap kullanmakta bu kadar kararlısın 
        # iyi bakalım :D

        for yapX in $(seq 1 $(wc -l ${setyapf} | awk '{print $1}')) ; do
            # line by line
            setline="$(cat ./${setyapf} | awk NR==${yapX})"
            
            # determine function
            if [[ $(echo "${setline}" | awk '{print $1}') = [pP][oO][sS][tT] ]] ; then
                post "$(echo "${setline}" | awk '{print $2}')" "$(echo "${setline}" | awk '{print $3}')" || { echo -e "Error occured in \033[0;31m${setyapf}\033[0m at line \033[0;31m${yapX}\033[0m" ; return 1;} 
            elif [[ $(echo "${setline}" | awk '{print $1}') = [cC][oO][pP][yY] ]] ; then
                copy "$(echo "${setline}" | awk '{print $2}')" "$(echo "${setline}" | awk '{print $3}')" "$(echo "${setline}" | awk '{print $4}')" || { echo -e "Error occured in \033[0;31m${setyapf}\033[0m at line \033[0;31m${yapX}\033[0m" ; return 1;} 
            else
                echo -e "\033[0;31m${BASH_SOURCE[0]}\033[0m: i can't determine the function: ${yapX}"
                # return 1
            fi
        done

    else
        echo -e "\033[0;31m${BASH_SOURCE[0]}\033[0m: i can't find the metadata file."
        return 1
    fi
}

case "${1}" in
    # Tersine işlem
    [rR][eE][vV][eE][rR][sS][eE]|--[rR][eE][vV][eE][rR][sS][eE]|-[rR])
        __make reverse
    ;;

    # Ön tanımlı olarak gidiş fonksyonu yüklenir edilir 
    # yani kurulum
    ""|" "|[mM][aA][kK][eE]|--[mM][aA][kK][eE]|-[mM])
        __make flat
    ;;

    # Version
    # $package $version $maintainer

    [vV][eE][rR][ßS][iI][oO][nN])
        echo "$package $version $maintainer" # echo x ; exit $? > printf x
    ;;

    # Yardım
    [hH][eE][lL][pP]|--[hH][eE][lL][pP]|-[hH])
        echo "Arguments: --reverse, --make (default), --help
--reverse: finds and deletes prepared files by doing the opposite of installation.

--make: standard installation process.

--version: shows current version and maintainer of $package.

--help: shows this screen.
"
    ;;
    
    *)
        echo -e "Arguments: --reverse, --make (default), --help\n type '${BASHSOURCE[0]} --help' for more information."
    ;;
esac

# 15-10-2021
# temel install komutlarının tanımlama işlemleri tamamlandı geriye sadece remove kaldı
# main case düzenlenmeli
# şu an copy reverse komutundayız

# 21-10-2021

# To Do:
# dizin listesi (sistem üzerinde kurulmuş ele alınarak)
# dosyalar kurulu mu değil mi? sadece kurulular sadece kaldırılmış olanlar.
# get fonksiyonu