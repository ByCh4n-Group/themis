#!/bin/bash

#    themis themis bash text bank - themis
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

# set directory
btb_setdir="${PWD}"

# bash text bank file extention
btbfe="btb"

# fonksyonlar tek tek kullanılacak şekilde ayarlanmıştır 
# kısa scriptler ile siz bunları istediğiniz gibi ayarlayabilirsiniz

__btbtm() {
    # Bash Text Bank Temp Direcotry Manager
    case ${1} in
        [sS][tT][aA][rR][tT])
            [[ -d "/tmp/${BASH_SOURCE[0]}" ]] || mkdir -p "/tmp/${BASH_SOURCE[0]}"
        ;;
        [sS][tT][oO][pP])
            [[ -d "/tmp/${BASH_SOURCE[0]}" ]] && rm -rf "/tmp/${BASH_SOURCE[0]}"
        ;;
        [rR][eE][sS][tT][aA][rR][tT])
            [[ -d "/tmp/${BASH_SOURCE[0]}" ]] && rm -rf "/tmp/${BASH_SOURCE[0]}"
            [[ -d "/tmp/${BASH_SOURCE[0]}" ]] || mkdir -p "/tmp/${BASH_SOURCE[0]}"
        ;;
        *)
            return 1
        ;;
    esac
}

__btbm() {
    case ${1} in
        [oO]|[oO][pP][eE][nN])
            if [[ $(file "${2}" | grep "gzip compressed data") ]] ; then 
                if [[ ! -d "/tmp/${BASH_SOURCE[0]}" ]] ; then
                    __btbtm start && cp "${2}" "/tmp/${BASH_SOURCE[0]}" && cd "/tmp/${BASH_SOURCE[0]}"
                    tar -xf "$(basename ${2})" && rm "$(basename ${2})"
                    source metadata
                else
                    return 1
                fi
            else
                return 1
            fi
        ;;
        [cC]|[cC][lL][oO][sS][eE])
            if [[ -f "/tmp/${BASH_SOURCE[0]}/metadata" ]] ; then
                cd "/tmp/${BASH_SOURCE[0]}" && source metadata
                tar -czf "${btb_setdir}/${btb_setbankname}.${btbfe}" ./* && cd ${btb_setdir} && __btbtm stop || return 2
            else
                return 1
            fi
        ;;
        *)
            return 1
        ;;
    esac
}

btb-create-bank() {
    # Çıkış durumları:
    # 1: belirtilen değer boş veya boşluklu

    # en fazla 1 parametre ile kullanılır
    # bank isimlerinde boşluk bulunmaz
    if ! [[ -z ${1} ]] && [[ $(echo "${1}" | grep " ") = "" ]] ; then 
        __btbtm start && cd "/tmp/${BASH_SOURCE[0]}"
        echo "btb_setbankname='${1}'" > metadata
        __btbm close && { __btbtm stop && return 0 ; } || {  __btbtm stop && return 2 ;}
    else
        return 1
    fi
}

btb-create-base() {
    # Çıkış durumları:
    # 1: yetersiz argüman
    # 2: belirtlilen ilk argv yani ${1} bir gzip dosyası değil veya exctract edilemedi
    if [[ ${#} -gt 1 ]] ; then
        __btbm open ${1} && __littlebutterfly="true" || __littlebutterfly="false"
        if [[ ${__littlebutterfly} = "true" ]] ; then
            for btbX in $(seq 2 ${#}) ; do
                if [[ $(echo "${@:btbX:1}" | grep " ") = "" ]] ; then
                    [[ ! -d "${@:btbX:1}" ]] && { mkdir "${@:btbX:1}" && echo "Created: ${@:btbX:1}@${btb_setbankname}" || echo "Couldn't crated ${@:btbX:1}" ; } || echo "${@:btbX:1}: is already exist in ${btb_setbankname}."
                fi
            done
            __btbm close
        else
            __btbtm stop
            return 2
        fi
    else
        return 1
    fi
}

btb-remove-base() {
    # Çıkış durumları:
    # 1: yetersiz argüman
    # 2: belirtlilen ilk argv yani ${1} bir gzip dosyası değil veya exctract edilemedi
    if [[ ${#} -gt 1 ]] ; then
        __btbm open ${1} && __littlebutterfly="true" || __littlebutterfly="false"
        if [[ ${__littlebutterfly} = "true" ]] ; then
            for btbX in $(seq 2 ${#}) ; do
                if [[ $(echo "${@:btbX:1}" | grep " ") = "" ]] ; then
                    [[ -d "${@:btbX:1}" ]] && { rm -rf "${@:btbX:1}" && echo "Removed: ${@:btbX:1}@${btb_setbankname} -> /dev/null" || echo "Couldn't removed ${@:btbX:1}. So doesn't exist" ; } || echo "Couldn't removed ${@:btbX:1}. So doesn't exist"
                fi
            done
            __btbm close
        else
            __btbtm stop
            return 2
        fi
    else
        return 1
    fi
}

btb-check-base() {
    # Çıkış durumları:
    # 1: yetersiz argüman
    # 2: belirtlilen ilk argv yani ${1} bir gzip dosyası değil veya exctract edilemedi
    if [[ ${#} -eq 2 ]] ; then
        __btbm open ${1} && __littlebutterfly="true" || __littlebutterfly="false"
        if [[ ${__littlebutterfly} = "true" ]] ; then
            if [[ $(echo "${2}" | grep " ") = "" ]] ; then
                [[ -d "${2}" ]] && { echo "${2}: found" ; } || { echo "${2}: doesn't exist" ; }
            fi
            __btbm close
        else
            __btbtm stop
            return 2
        fi
    else
        return 1
    fi
}

btb-write-data() {
    # Çıkış durumları:
    # 1: argv değerleri belirtilen aralıkta değil
    
    # bank base file (data)
    if [[ ${#} -ge 3 ]] && [[ ${#} -lt 5 ]] ; then
        :
    else
        return 1
    fi
}

interactive() {
    # bu en altta olacak
    :
}