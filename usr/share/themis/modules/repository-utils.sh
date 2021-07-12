#!/bin/bash

updateindex() {
    if [[ ! -z ${1} ]] ; then
        netcheck -e
        [ -d /tmp/themis/index ] && rm -rf /tmp/themis/index
        mkdir -p /tmp/themis/index && cd /tmp/themis/index
        maintainer=""
        reponame=""
        packages=""
        wget "${1}/index.sh" && source ./index.sh || repostatus="bad"
        repostatus="nice"
        [[ -z ${maintainer} ]] && maintainer="anyone"
        [[ -z ${reponame} ]] && repostatus="bad"
        [[ -z ${#packages[@]} ]] && repostatus="bad"
        if [[ ${repostatus} = "nice" ]] ; then
            if [ -d "${repodir}/${reponame}" ] ; then
                if [ -e "${repodir}/${reponame}/index.sh" ] ; then
                    if [[ "$(sha256sum index.sh | awk '{print $1}')" != "$(sha256sum ${repodir}/${reponame}/index.sh | awk '{print $1}')" ]] ; then
                        rm "${repodir}/${reponame}/index.sh" && { cp ./index.sh "${repodir}/${reponame}" ; success "${reponame}: updated successfully and no error(s) reported: ${reponame} by ${maintainer} and there are $((${#packages[@]} - 1)) package(s)" ; } 
                    else
                        success "${reponame} is already up to date: ${reponame} by ${maintainer} and there are $((${#packages[@]} - 1)) package(s)"
                    fi
                fi
            else
                [[ ! -d "${repodir}/${reponame}" ]] && mkdir -p "${repodir}/${reponame}" && { cp ./index.sh "${repodir}/${reponame}" && success "${reponame} added: ${reponame} by ${maintainer} and there are $((${#packages[@]} - 1)) package(s)" ; }
            fi
        elif [[ ${repostatus} = "bad" ]] ; then
            error "repository ${1} has bad configured"
            status="bad"
        fi
    else
        error "repository not specified"
        status="bad"
    fi
    [ -d /tmp/themis ] && rm -rf /tmp/themis
}

frrik() {
    if [[ ! -z ${1} ]] ; then
        netcheck -e
        [ -d /tmp/themis/getpackage ] && rm -rf /tmp/themis/getpackage
        mkdir -p /tmp/themis/getpackage
        for y in $(seq 1 $(ls ${repodir} | wc -l)) ; do
            if [[ ${found} = "yes" ]] ; then
                break
            fi
            setrepomdir="$(ls ${repodir} | awk NR==$y'{print $1}')"
            if [ -e "${repodir}/${setrepomdir}/index.sh" ] ; then
                maintainer=""
                reponame=""
                packages=""
                source "${repodir}/${setrepomdir}/index.sh"
                getstatus="nice"
                [ -z ${maintainer} ] && maintainer="anyone"
                [ -z ${reponame} ] && getstatus="bad"
                [[ -z ${packages[@]} ]] && getstatus="bad"
                if [[ ${getstatus} = "nice" ]] ; then
                    for x in $(seq 1 ${#packages[@]}) ; do
                        if [[ $(echo "${packages[x]}" | tr "_" " " | awk '{print $2}') = "${1}" ]] ; then
                            setchar="#"
                            centexpad "->"
                            filename="$(basename $(echo "${packages[x]}" | tr "_" " " | awk '{print $1}'))"
                            packagename="$(echo "${packages[x]}" | tr "_" " " | awk '{print $2}')"
                            packageversion="$(echo "${packages[x]}" | tr "_" " " | awk '{print $3}')"
                            setchar=""
                            echo -en "(${green}$((${i} - 1 ))${reset} / ${green}${mma}${reset}) - " ; success "${packages[x]} has founded at ${reponame}"
                            cd /tmp/themis/getpackage
                            wget "${packages[0]}/$(echo "${packages[x]}" | tr "_" " " | awk '{print $1}')" && installpackage "/tmp/themis/getpackage/${filename}" "${filename}" || { error "file ${filename} can not downloaded on ${packages[0]}" ; status="bad" ; } 
                            setchar="#"
                            centexpad "<-"
                            setchar=""
                            found="yes"
                            break
                        fi
                    done
                elif [[ ${getstatus} = "bad" ]] ; then
                    error "${setrepomdir} has bad configured please reupdate index"
                    status="bad"
                fi
            else
                error "repository ${setrepomdir} has no index.sh file so bad configured"
                status="bad"
            fi
        done
        if [[ ${found} = "no" ]] ; then
            echo -en "(${red}$((${i} - 1 ))${reset} / ${red}${mma}${reset}) - " ; error "${1} not found"
            status="bad"
        fi
    else
        error "package not specified"
        status="bad"
    fi
    [ -d /tmp/themis ] && rm -rf /tmp/themis
}
