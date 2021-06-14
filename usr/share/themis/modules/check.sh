#!/bin/bash

check-all() {
    :
}

checkedepedns() {
    for y in $(seq 1 ${#}) ; do
        if ! [ $(command -v ${@:y:1}) ] ; then 
            error "${@:y:1} not found. Please install that package."
            checkedepednsstatus="bad"
        fi
    done
    [[ ${checkedepednsstatus} = "bad" ]] && error "Some Dependence(s) Are Not Found Please Install The Dependence(s)." "e"
}