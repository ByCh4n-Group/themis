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
        [ -z ${maintainer} ] && maintainer="anyone"
        [ -z ${reponame} ] && repostatus="bad"
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