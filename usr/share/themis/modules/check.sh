#!/bin/bash

check-all() {
    [ -d /usr/share/themis ] || error "main directory not found" "e"
    [ -d /usr/share/themis/packages ] || error "packages metadata directory not found please execute command: 'sudo mkdir -p /usr/share/themis/packages'" "e"
    [ -d /usr/share/themis/repositories ] || error "repositories directory not found please execute command: 'sudo mkdir -p /usr/share/themis/repositories'" "e"
    [ -e /usr/bin/themis ] || error "trigger not found" "e"
    [ -e /usr/share/themis/index.sh ] || warn "index.sh not found in main directory so you cant use package management system of themis if you want to use it please reinstall correctly themis"
    [ $(command -v tar) ] || error "tar not found so you can't use the system please install it" "e"
    [ $(command -v wget) ] || warn "wget not found so you can't use package management system of themis"
    [ $(command -v pip3) ] || warn "pip3 not found so you can't use python3 dependences in your packages"
    [ $(command -v gem) ] || warn "gem not found so you can't use ruby dependences in your packages"
}

checkdepedns() {
    for y in $(seq 1 ${#}) ; do
        if ! [ $(command -v ${@:y:1}) ] ; then  
            error "${@:y:1} not found. Please install that package."
            checkedepednsstatus="bad"
        fi
    done
    [[ ${checkedepednsstatus} = "bad" ]] && error "Some Dependence(s) Are Not Found Please Install The Dependence(s)." "e"
}