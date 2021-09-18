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

# metadata
btbver="1.0.0"
btbmaintainer="lazypwny751"

# fonksyonlar tek tek kullanılacak şekilde ayarlanmıştır 
# kısa scriptler ile siz bunları istediğiniz gibi ayarlayabilirsiniz

__btbtm() {
    # Bash Text Bank Temp Direcotry Manager
    case ${1} in
        [sS][tT][aA][rR][tT])
            [[ -d "/tmp/$(basename ${BASH_SOURCE[0]})" ]] || mkdir -p "/tmp/$(basename ${BASH_SOURCE[0]})"
        ;;
        [sS][tT][oO][pP])
            [[ -d "/tmp/$(basename ${BASH_SOURCE[0]})" ]] && rm -rf "/tmp/$(basename ${BASH_SOURCE[0]})"
        ;;
        [rR][eE][sS][tT][aA][rR][tT])
            [[ -d "/tmp/$(basename ${BASH_SOURCE[0]})" ]] && rm -rf "/tmp/$(basename ${BASH_SOURCE[0]})"
            [[ -d "/tmp/$(basename ${BASH_SOURCE[0]})" ]] || mkdir -p "/tmp/$(basename ${BASH_SOURCE[0]})"
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
                if [[ ! -d "/tmp/$(basename ${BASH_SOURCE[0]})" ]] ; then
                    __btbtm start && cp "${2}" "/tmp/$(basename ${BASH_SOURCE[0]})" && cd "/tmp/$(basename ${BASH_SOURCE[0]})"
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
            if [[ -f "/tmp/$(basename ${BASH_SOURCE[0]})/metadata" ]] ; then
                cd "/tmp/$(basename ${BASH_SOURCE[0]})" && source metadata
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
        __btbtm start && cd "/tmp/$(basename ${BASH_SOURCE[0]})"
        echo "btb_setbankname='${1}'" > metadata
        __btbm close && { __btbtm stop && return 0 ; } || {  __btbtm stop && return 2 ;}
    else
        echo "Bank names cannot have spaces."
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
                [[ -d "${2}" ]] && { echo "[+] ${2}: exist" ; } || { echo "[-] ${2}: doesn't exist" ; }
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
    if [[ ${#} -ge 3 ]] && [[ ${#} -le 4 ]] ; then
        __btbm open "${1}" && bwd="true" || bwd="false"
        if [[ ${bwd} = "true" ]] ; then
            if [[ -d ${2} ]] ; then
                if [[ ! -z ${3} ]] ; then
                    echo "${4}" > ./"${2}"/"${3}"
                    __btbm close && return 0 || return 1
                else
                    echo "data '${3}' not found in '${2}'"
                    __btbm close
                    return 1
                fi
            else
                echo "base '${2}' doesn't exist"
                __btbm close
                return 1
            fi
        else
            __btbtm stop
            return 1
        fi
    else
        echo "insufficient argument"
        return 1
    fi
}

btb-write-datail() {
    # just added more > (so 2 times '>>') lol
    if [[ ${#} -ge 3 ]] && [[ ${#} -le 4 ]] ; then
        __btbm open "${1}" && bwd="true" || bwd="false"
        if [[ ${bwd} = "true" ]] ; then
            if [[ -d ${2} ]] ; then
                if [[ ! -z ${3} ]] ; then
                    echo "${4}" >> ./"${2}"/"${3}"
                    __btbm close && return 0 || return 1
                else
                    echo "data '${3}' not found in '${2}'"
                    __btbm close
                    return 1
                fi
            else
                echo "base '${2}' doesn't exist"
                __btbm close
                return 1
            fi
        else
            __btbtm stop
            return 1
        fi
    else
        echo "insufficient argument"
        return 1
    fi
}

btb-add-data() {
    if [[ ${#} -gt 2 ]] ; then
        if [[ -f "${3}" ]] ; then
            filepath="$(realpath ${3})"
            __btbm open "${1}" && bad="true" || bad="false"
            if [[ ${bwd} = "true" ]] ; then
                if [[ -d "${2}" ]] ; then
                    cp "${filepath}" "${2}"
                    __btbm close
                else
                    echo "hmm.. seems like '${2}' doesn't exist"
                    __btbm close && return 1 || return 2
                fi
            else
                __btbtm stop && return 1 || return 2
            fi
        else
            echo "i can't find '${3}'"
            return 1
        fi
    else
        echo "insufficient argument"
        return 1
    fi
}

btb-remove-data() {
    if [[ ${#} -ge 3 ]] ; then
        __btbm open "${1}" && brd="true" || brd="false"
        if [[ ${brd} = "true" ]] ; then
            if [[ -d ${2} ]] ; then
                for brdX in $(seq 3 ${#}) ; do
                    if [[ -f ./"${2}"/"${@:brdX:1}" ]] ; then
                        rm ./"${2}"/"${@:brdX:1}" && echo "${@:brdX:1} is removed successfully from nothingness" || brdstatus="false"
                    else
                        echo "hmm.. it seems ${@:brdX:1} is not in ${2}"
                    fi
                    __btbm close
                    if [[ ${brdstatus} = "false" ]] ; then
                        return 1
                    else
                        return 0
                    fi
                done
            else
                echo "base '${2}' doesn't exist"
                __btbm close
                return 1
            fi
        else
            __btbtm stop
            return 1
        fi
    else
        echo "insufficient argument"
        return 1
    fi
}

btb-check-data() {
    if [[ ${#} -eq 3 ]] ; then
        __btbm open "${1}" && bcd="true" || bcd="false"
        if [[ ${bcd} = "true" ]] ; then
            if [[ -d ./"${2}" ]] ; then
                if [[ -f ./"${2}"/"${3}" ]] ; then
                    echo "[+] data '${3}' is exist in '${2}'"
                    __btbm close
                    return 0
                else
                    echo "[-] data '${3}' doesn't exist in '${2}'"
                    __btbm close
                    return 1
                fi
            else
                echo "base '${2}' doesn't exist."
                __btbm close && return 1 || return 2
            fi
        else
            __btbtm stop
            return 1
        fi
    else
        echo "arguments are not in the specified range"
        return 1
    fi
}

btb-call-data() {
    if [[ ${#} -eq 3 ]] ; then
        __btbm open "${1}" && bcd="true" || bcd="false"
        if [[ ${bcd} = "true" ]] ; then
            if [[ -d ./"${2}" ]] ; then
                if [[ -f ./"${2}"/"${3}" ]] ; then
                    cat ./"${2}"/"${3}"
                    __btbm close
                    return 0
                else
                    echo "[-] data '${3}' doesn't exist in '${2}'"
                    __btbm close
                    return 1
                fi
            else
                echo "base '${2}' doesn't exist."
                __btbm close && return 1 || return 2
            fi
        else
            __btbtm stop
            return 1
        fi
    else
        echo "arguments are not in the specified range"
        return 1
    fi
}

btb-call-index() {
    if [[ ! -z "${1}" ]] ; then
        __btbm open "${1}" && bcx="true" || bcx="false"
        if [[ ${bcx} = "true" ]] ; then
            case "${2}" in
                [lL][iI][sS][tT]-[bB][aA][sS][eE]|--[lL][iI][sS][tT]-[bB][aA][sS][eE]|-[lL][bB])
                    ls -d */
                ;;
                [lL][iI][sS][tT]-[dD][aA][tT][aA]|--[lL][iI][sS][tT]-[dD][aA][tT][aA]|-[lL][dD])
                    if [[ -d "${3}" ]] ; then
                        ls -p "${3}" | grep -v /
                    else
                        echo "base '${3}' doesn't exist"
                    fi
                ;;
                [nN][uU][mM][bB][eE][rR]-[bB][aA][sS][eE]|--[nN][uU][mM][bB][eE][rR]-[bB][aA][sS][eE]|-[nN][bB])
                    ls -d */ | wc -l
                ;;
                [nN][uU][mM][bB][eE][rR]-[dD][aA][tT][aA]|--[nN][uU][mM][bB][eE][rR]-[dD][aA][tT][aA]|-[nN][dD])
                    if [[ -d "${3}" ]] ; then
                        ls -p "${3}" | grep -v / | wc -l
                    else
                        echo "base '${3}' doesn't exist"
                    fi
                ;;
                *)
                    echo "default (none of above)"
                ;;
            esac
            __btbm close && return 0 || return 2
        else
            __btbm close && return 1 || return 2
        fi
    else
        echo "Please give me any .${btbfe} file ;-;"
        return 1
    fi
}

#   in bank > 
#       base    >
#           data    >

interactive() {

    _itok() {
        if [[ $? = 0 ]] ; then
            echo -e "\033[0;32m[+] the operation completed and no error(s) occured\033[0m."
        else
            echo -e "\033[0;31m[-] the operation not comleted because some error(s) occured please check that options\033[0m."
        fi
    }

    while :; do
        echo -ne "\033[0;34mbtb-${btbver}\033[0m:\033[0;35m>\033[0m " ; read ii
        case "${ii}" in
            [cC][rR][eE][aA][tT][eE][-" "][bB][aA][nN][kK])
                savedir="${btb_setdir}"
                bankname="bash-text-bank"
                while :; do
                    echo -ne "\033[0;34mbtb-${btbver}\033[0m\033[0m\033[0m/\033[0;34mcreate-bank\033[0m:\033[0;35m>\033[0m " ; read cbi
                    case "${cbi}" in
                        [sS][hH][oO][wW][-" "][oO][pP][tT][iI][oO][nN][sS])
                            echo -e "* savedir=${savedir}\n* bankname=${bankname}"
                        ;;
                        savedir=*)
                            export "${cbi}" && echo "${cbi}"
                        ;;
                        bankname=*)
                            export "${cbi}" && echo "${cbi}"
                        ;;
                        [rR][uU][nN])
                            if [[ -d "${savedir}" ]] && [[ ! -z ${bankname} ]] && [[ $(echo "${bankname}" | grep " ") = "" ]] ; then
                                btb-create-bank "${bankname}" 
                                if [[ "$(basename ${btb_setdir})" != "$(basename ${savedir})" ]] ; then 
                                    mv "${btb_setdir}"/"${bankname}.${btbfe}" "${savedir}" 2> /dev/null
                                fi
                                _itok
                            else
                                echo "Some options aren't ok please check that options and try again."
                            fi
                        ;;
                        [hH][eE][lL][pP])
                        ;;
                        [cC][lL][eE][aA][rR])
                            clear
                        ;;
                        [eE][xX][eE][cC]" "*)
                            ${cbi:5}
                        ;;
                        [bB][aA][cC][kK])
                            break
                        ;;
                        [eE][xX][iI][tT])
                            exit 0
                        ;;
                        *)
                            echo "'$([[ -z ${cbi} ]] && echo ' ' || echo ${cbi})' is an unknow option type 'help' to see what it can do there."
                        ;;
                    esac
                done
            ;;
            [cC][rR][eE][aA][tT][eE][-" "][bB][aA][sS][eE])
                while :; do
                    echo -ne "\033[0;34mbtb-${btbver}\033[0m\033[0m\033[0m/\033[0;34mcreate-base\033[0m:\033[0;35m>\033[0m " ; read cbei
                    case "${cbei}" in
                        [sS][hH][oO][wW][-" "][oO][pP][tT][iI][oO][nN][sS])
                            echo -e "* bank=${bank}\n* basename=${basename}"
                        ;;
                        bank=*)
                            export "${cbei}" && echo "${cbei}"
                        ;;
                        basename=*)
                            export "${cbei}" && echo "${cbei}"
                        ;;
                        [rR][uU][nN])
                            if [[ $(file "${bank}" | grep "gzip compressed data") ]] && [[ ! -z "${basename}" ]] ; then
                                btb-create-base "${bank}" "${basename}"
                                _itok
                            else
                                echo "Some options aren't ok please check that options and try again."
                            fi
                        ;;
                        [hH][eE][lL][pP])
                        ;;
                        [cC][lL][eE][aA][rR])
                            clear
                        ;;
                        [eE][xX][eE][cC]" "*)
                            ${cbei:5}
                        ;;
                        [bB][aA][cC][kK])
                            break
                        ;;
                        [eE][xX][iI][tT])
                            exit 0
                        ;;
                        *)
                            echo "'$([[ -z ${cbei} ]] && echo ' ' || echo ${cbei})' is an unknow option type 'help' to see what it can do there."
                        ;;
                    esac
                done
            ;;
            [rR][eE][mM][oO][vV][eE][-" "][bB][aA][sS][eE])
                while :; do
                    echo -ne "\033[0;34mbtb-${btbver}\033[0m\033[0m\033[0m/\033[0;34mremove-base\033[0m:\033[0;35m>\033[0m " ; read rbi
                    case "${rbi}" in
                        [sS][hH][oO][wW][-" "][oO][pP][tT][iI][oO][nN][sS])
                            echo -e "* bank=${bank}\n* basename=${basename}"
                        ;;
                        bank=*)
                            export "${rbi}" && echo "${rbi}" 
                        ;;
                        basename=*)
                            export "${rbi}" && echo "${rbi}"
                        ;;
                        [rR][uU][nN])
                            if [[ $(file "${bank}" | grep "gzip compressed data") ]] && [[ ! -z "${basename}" ]] ; then
                                btb-remove-base "${bank}" "${basename}"
                                _itok
                            else
                                echo "Some options aren't ok please check that options and try again."
                            fi                        
                        ;;
                        [hH][eE][lL][pP])
                        ;;
                        [cC][lL][eE][aA][rR])
                            clear
                        ;;
                        [eE][xX][eE][cC]" "*)
                            ${rbi:5}
                        ;;
                        [bB][aA][cC][kK])
                            break
                        ;;
                        [eE][xX][iI][tT])
                            exit 0
                        ;;
                        *)
                            echo "'$([[ -z ${rbi} ]] && echo ' ' || echo ${rbi})' is an unknow option type 'help' to see what it can do there."
                        ;;
                    esac
                done
            ;;
            [cC][hH][eE][cC][kK][-" "][bB][aA][sS][eE])
                while :; do
                    echo -ne "\033[0;34mbtb-${btbver}\033[0m\033[0m\033[0m/\033[0;34mcheck-base\033[0m:\033[0;35m>\033[0m " ; read cbit            
                    case "${cbit}" in
                        [sS][hH][oO][wW][-" "][oO][pP][tT][iI][oO][nN][sS])
                            echo -e "* bank=${bank}\n* basename=${basename}"
                        ;;
                        bank=*)
                            export "${cbit}" && echo "${cbit}" 
                        ;;
                        basename=*)
                            export "${cbit}" && echo "${cbit}"
                        ;;
                        [rR][uU][nN])
                            if [[ $(file "${bank}" | grep "gzip compressed data") ]] && [[ ! -z "${basename}" ]] ; then
                                btb-check-base "${bank}" "${basename}"
                            else
                                echo "Some options aren't ok please check that options and try again."
                            fi                        
                        ;;                        
                        [hH][eE][lL][pP])
                        ;;
                        [cC][lL][eE][aA][rR])
                            clear
                        ;;
                        [eE][xX][eE][cC]" "*)
                            ${cbi:5}
                        ;;
                        [bB][aA][cC][kK])
                            break
                        ;;
                        [eE][xX][iI][tT])
                            exit 0
                        ;;
                        *)
                            echo "'$([[ -z ${cbit} ]] && echo ' ' || echo ${cbit})' is an unknow option type 'help' to see what it can do there."
                        ;;
                    esac
                done
            ;;
            [wW][rR][iI][tT][eE][-" "][dD][aA][tT][aA])
                while :; do
                    echo -ne "\033[0;34mbtb-${btbver}\033[0m\033[0m\033[0m/\033[0;34mwrite-data\033[0m:\033[0;35m>\033[0m " ; read wdi
                    case "${wdi}" in
                        [sS][hH][oO][wW][-" "][oO][pP][tT][iI][oO][nN][sS])
                            echo -e "* bank=${bank}\n* basename=${basename}\n* filename=${filename}\ndata=${data}"
                        ;;
                        bank=*)
                            export "${wdi}" && echo "${wdi}"
                        ;;
                        basename=*)
                            export "${wdi}" && echo "${wdi}"
                        ;;
                        filename=*)
                            export "${wdi}" && echo "${wdi}"
                        ;;
                        data=*)
                            export "${wdi}" && echo "${wdi}"
                        ;;
                        [rR][uU][nN])
                            if [[ $(file "${bank}" | grep "gzip compressed data") ]] && [[ ! -z "${basename}" ]] && [[ ! -z "${filename}" ]] ; then
                                btb-write-data "${bank}" "${basename}" "${filename}" "${data}"
                                _itok
                            else
                                echo "Some options aren't ok please check that options and try again."
                            fi
                        ;;
                        [hH][eE][lL][pP])
                        ;;
                        [cC][lL][eE][aA][rR])
                            clear
                        ;;
                        [eE][xX][eE][cC]" "*)
                            ${wdi:5}
                        ;;
                        [bB][aA][cC][kK])
                            break
                        ;;
                        [eE][xX][iI][tT])
                            exit 0
                        ;;
                        *)
                            echo "'$([[ -z ${wdi} ]] && echo ' ' || echo ${wdi})' is an unknow option type 'help' to see what it can do there."
                        ;;
                    esac
                done
            ;;
            [wW][rR][iI][tT][eE][-" "][dD][aA][tT][aA][iI][lL])
                while :; do
                    echo -ne "\033[0;34mbtb-${btbver}\033[0m\033[0m\033[0m/\033[0;34mwrite-data\033[0m:\033[0;35m>\033[0m " ; read wdi
                    case "${wdi}" in
                        [sS][hH][oO][wW][-" "][oO][pP][tT][iI][oO][nN][sS])
                            echo -e "* bank=${bank}\n* basename=${basename}\n* filename=${filename}\ndata=${data}"
                        ;;
                        bank=*)
                            export "${wdi}" && echo "${wdi}"
                        ;;
                        basename=*)
                            export "${wdi}" && echo "${wdi}"
                        ;;
                        filename=*)
                            export "${wdi}" && echo "${wdi}"
                        ;;
                        data=*)
                            export "${wdi}" && echo "${wdi}"
                        ;;
                        [rR][uU][nN])
                            if [[ $(file "${bank}" | grep "gzip compressed data") ]] && [[ ! -z "${basename}" ]] && [[ ! -z "${filename}" ]] ; then
                                btb-write-datail "${bank}" "${basename}" "${filename}" "${data}"
                                _itok
                            else
                                echo "Some options aren't ok please check that options and try again."
                            fi
                        ;;
                        [hH][eE][lL][pP])
                        ;;
                        [cC][lL][eE][aA][rR])
                            clear
                        ;;
                        [eE][xX][eE][cC]" "*)
                            ${wdi:5}
                        ;;
                        [bB][aA][cC][kK])
                            break
                        ;;
                        [eE][xX][iI][tT])
                            exit 0
                        ;;
                        *)
                            echo "'$([[ -z ${wdi} ]] && echo ' ' || echo ${wdi})' is an unknow option type 'help' to see what it can do there."
                        ;;
                    esac
                done
            ;;
            [rR][eE][mM][oO][vV][eE][-" "][dD][aA][tT][aA])
                while :; do
                    echo -ne "\033[0;34mbtb-${btbver}\033[0m\033[0m\033[0m/\033[0;34mremove-data\033[0m:\033[0;35m>\033[0m " ; read rdi
                    case "${rdi}" in
                        [sS][hH][oO][wW][-" "][oO][pP][tT][iI][oO][nN][sS])
                            echo -e "* bank=${bank}\n* basename=${basename}\n* filename=${filename}"
                        ;;
                        bank=*)
                            export "${rdi}" && echo "${rdi}"
                        ;;
                        basename=*)
                            export "${rdi}" && echo "${rdi}"
                        ;;
                        filename=*)
                            export "${rdi}" && echo "${rdi}"
                        ;;
                        [rR][uU][nN])
                            if [[ $(file "${bank}" | grep "gzip compressed data") ]] && [[ ! -z "${basename}" ]] && [[ ! -z "${filename}" ]] ; then
                                btb-remove-data "${bank}" "${basename}" "${filename}"
                                _itok
                            else
                                echo "Some options aren't ok please check that options and try again."
                            fi
                        ;;
                        [hH][eE][lL][pP])
                        ;;
                        [cC][lL][eE][aA][rR])
                            clear
                        ;;
                        [eE][xX][eE][cC]" "*)
                            ${rdi:5}
                        ;;
                        [bB][aA][cC][kK])
                            break
                        ;;
                        [eE][xX][iI][tT])
                            exit 0
                        ;;
                        *)
                            echo "'$([[ -z ${rdi} ]] && echo ' ' || echo ${rdi})' is an unknow option type 'help' to see what it can do there."
                        ;;
                    esac
                done
            ;;
            [cC][hH][eE][cC][kK][-" "][dD][aA][tT][aA])
                while :; do
                    echo -ne "\033[0;34mbtb-${btbver}\033[0m\033[0m\033[0m/\033[0;34mcheck-data\033[0m:\033[0;35m>\033[0m " ; read cdi
                    case "${cdi}" in
                        [sS][hH][oO][wW][-" "][oO][pP][tT][iI][oO][nN][sS])
                            echo -e "* bank=${bank}\n* basename=${basename}\n* filename=${filename}"
                        ;;
                        bank=*)
                            export "${cdi}" && echo "${cdi}"
                        ;;
                        basename=*)
                            export "${cdi}" && echo "${cdi}"
                        ;;
                        filename=*)
                            export "${cdi}" && echo "${cdi}"
                        ;;
                        [rR][uU][nN])
                            if [[ $(file "${bank}" | grep "gzip compressed data") ]] && [[ ! -z "${basename}" ]] && [[ ! -z "${filename}" ]] ; then
                                btb-cdi-data "${bank}" "${basename}" "${filename}"
                            else
                                echo "Some options aren't ok please check that options and try again."
                            fi
                        ;;
                        [hH][eE][lL][pP])
                        ;;
                        [cC][lL][eE][aA][rR])
                            clear
                        ;;
                        [eE][xX][eE][cC]" "*)
                            ${cdi:5}
                        ;;
                        [bB][aA][cC][kK])
                            break
                        ;;
                        [eE][xX][iI][tT])
                            exit 0
                        ;;
                        *)
                            echo "'$([[ -z ${cdi} ]] && echo ' ' || echo ${cdi})' is an unknow option type 'help' to see what it can do there."
                        ;;
                    esac
                done            
            ;;
            [cC][aA][lL][lL][-" "][dD][aA][tT][aA])
                while :; do
                    echo -ne "\033[0;34mbtb-${btbver}\033[0m\033[0m\033[0m/\033[0;34mcall-data\033[0m:\033[0;35m>\033[0m " ; read cdi
                    case "${cdi}" in
                        [sS][hH][oO][wW][-" "][oO][pP][tT][iI][oO][nN][sS])
                            echo -e "* bank=${bank}\n* basename=${basename}\n* filename=${filename}"
                        ;;
                        bank=*)
                            export "${cdi}" && echo "${cdi}"
                        ;;
                        basename=*)
                            export "${cdi}" && echo "${cdi}"
                        ;;
                        filename=*)
                            export "${cdi}" && echo "${cdi}"
                        ;;
                        [rR][uU][nN])
                            if [[ $(file "${bank}" | grep "gzip compressed data") ]] && [[ ! -z "${basename}" ]] && [[ ! -z "${filename}" ]] ; then
                                btb-call-data "${bank}" "${basename}" "${filename}"
                                _itok
                            else
                                echo "Some options aren't ok please check that options and try again."
                            fi
                        ;;
                        [hH][eE][lL][pP])
                        ;;
                        [cC][lL][eE][aA][rR])
                            clear
                        ;;
                        [eE][xX][eE][cC]" "*)
                            ${cdi:5}
                        ;;
                        [bB][aA][cC][kK])
                            break
                        ;;
                        [eE][xX][iI][tT])
                            exit 0
                        ;;
                        *)
                            echo "'$([[ -z ${cdi} ]] && echo ' ' || echo ${cdi})' is an unknow option type 'help' to see what it can do there."
                        ;;
                    esac
                done
            ;;
            [cC][aA][lL][lL][-" "][iI][nN][dD][eE][xX])
                while :; do
                    echo -ne "\033[0;34mbtb-${btbver}\033[0m\033[0m\033[0m/\033[0;34mcall-index\033[0m:\033[0;35m>\033[0m " ; read cii
                    case "${cii}" in
                        [sS][hH][oO][wW][-" "][oO][pP][tT][iI][oO][nN][sS])
                            echo -e "* option=${option}\n* bank=${bank}\n? basename=${basename}"
                        ;;
                        option=*)
                            export "${cii}" && echo "${cii}"
                        ;;
                        bank=*)
                            export "${cii}" && echo "${cii}"
                        ;;
                        basename=*)
                            export "${cii}" && echo "${cii}"
                        ;;
                        [rR][uU][nN])
                            if [[ ! -z "${option}" ]] && [[ $(file "${bank}" | grep "gzip compressed data") ]] ; then
                                case "${option}" in
                                    [lL][iI][sS][tT][-" "][bB][aA][sS][eE])
                                        btb-call-index "${bank}" -lb
                                        _itok
                                    ;;
                                    [nN][uU][mM][bB][eE][rR][-" "][bB][aA][sS][eE])
                                        btb-call-index "${bank}" -nb
                                        _itok
                                    ;;
                                    [lL][iI][sS][tT][-" "][dD][aA][tT][aA])
                                        if [[ ! -z "${basename}" ]] ; then
                                            btb-call-index "${bank}" -ld "${basename}"
                                            _itok
                                        else
                                            echo "the 'basename' required by this option please set that value of variable"
                                        fi
                                    ;;
                                    [nN][uU][mM][bB][eE][rR][-" "][dD][aA][tT][aA])
                                        if [[ ! -z "${basename}" ]] ; then
                                            btb-call-index "${bank}" -nd "${basename}"
                                            _itok
                                        else
                                            echo "the 'basename' required by this option please set that value of variable"
                                        fi
                                    ;;
                                esac
                            fi
                        ;;
                        [hH][eE][lL][pP])
                            echo -e "
 Variable:\t\t\t Value:\t\t\t Description:
option\t\t\t\tlist-base
option\t\t\t\tnumber-base
option\t\t\t\tlist-data
option\t\t\t\tnumber-data
"
                        ;;
                        [cC][lL][eE][aA][rR])
                            clear
                        ;;
                        [eE][xX][eE][cC]" "*)
                            ${cii:5}
                        ;;
                        [bB][aA][cC][kK])
                            break
                        ;;
                        [eE][xX][iI][tT])
                            exit 0
                        ;;
                        *)
                            echo "'$([[ -z ${cii} ]] && echo ' ' || echo ${cii})' is an unknow option type 'help' to see what it can do there."
                        ;;
                    esac
                done
            ;;
            [hH][eE][lL][pP])
                echo -e "
 \033[0;36mCommand\033[0m:\t\t\t \033[0;36mDescription\033[0m:
create  bank
create  base
remove  base
check   base
write   data
write datail
remove  data
check   data
call    data
call   index
"
            ;;
            [cC][lL][eE][aA][rR])
                clear
            ;;
            [eE][xX][eE][cC]" "*)
                ${ii:5}
            ;;
            [eE][xX][iI][tT])
                exit 0
            ;;
            *)
                echo -e "'\033[0;31m$([[ -z ${ii} ]] && echo ' ' || echo ${ii})\033[0m' is an unknow option type '\033[0;33mhelp\033[0m' to see what it can do there."
            ;;
        esac
    done
}

## Anime kızları gercektir:
# cmus https://www.youtube.com/watch?v=1Wy23sfAK6o&list=RDBIpw4ALolt4&index=2
# cmus https://www.youtube.com/watch?v=eEABgC2ZXwg

## Genel data yapısı:
# btb-write-data bank.btb base data
#        0          1       2    3
# bank>base(-1)>data

## Temel:
# bank oluştur          -> tamam +
# base(ler) oluştur     -> tamam +
# base(ler) sil         -> tamam +
# base kontrol          -> tamam +
# data yaz(oluştur)     -> tamam +
# data(lar) sil         -> tamam +
# data kontrol          -> tamam +
# data çağır            -> tamam +
# data ekle             -> tamam -
# data editle           -> 
# dosya ekle            -> tamam -

## Özellikler 1
# base list             -> tamam +
# data list             -> tamam +
# base sayı             -> tamam +
# data sayı             -> tamam +

## Opsyonel:
# data integer mı?