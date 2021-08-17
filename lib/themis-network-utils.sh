#!/bin/bash

__netcheck() {
    ping -q -w1 -c1 google.com &>/dev/null && netcheck="online" || netcheck="offline"
    case ${1} in
        print|PRINT|-p)
            echo "${netcheck}"
        ;;
        [eE][xX][iI][tT]|[eE]|-[eE]|[eE])
            [[ ${netcheck} = "offline" ]] && error "Internet connection is required for this function to work." 2
        ;;
    esac
}

