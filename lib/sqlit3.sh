#!/bin/bash

## set -e
## getlib "colorsh" "themis-operating-systems-utils" "themis-core-utils"

_req4sl3() {
    tos_check_opt="exit"
    check t "sqlite3" 
    tos_check_opt="return"
    check f "${themis_db}" || { fixit -db || error "the database: $(filename ${themis_db}) couldn't creating in this time." "2" ; }
}

__create_pkg() {
    # requirements
    _req4sl3

    # references
    pkg_name="${1}"
    pkg_version="${2}"
    pkg_maintainer="${3}"
    pkg_description="${4}"
    pkg_yap_codec="${5}"

    sqlite3 "${themis_db}" "INSERT INTO packages VALUES('${pkg_name}', '${pkg_version}', '${pkg_maintainer}', '${pkg_description}', '${pkg_yap_codec}')"
}

__check_pkg() {
    if [[ $(sqlite3 "${themis_db}" "SELECT * FROM packages WHERE pkg LIKE '${1}' LIMIT 1") != "" ]] ; then
        return 0
    else
        return 1
    fi
}

__call_pkg_rowid() {
    if $(__check_pkg "${1}" ) ; then
        sqlite3 "${themis_db}" "SELECT rowid FROM packages WHERE pkg LIKE '${1}' LIMIT 1"
    else
        return 1
    fi
}

__delete_pkg() {
    if $(__check_pkg "${1}") ; then
        sqlite3 "${themis_db}" "DELETE FROM packages WHERE rowid=$(__call_pkg_rowid ${1})"
    else
        return 1
    fi
}
 
__update_pkg_ver() {
    if $(__check_pkg "${1}") ; then
        sqlite3 "${themis_db}" "UPDATE package SET ver = '${2}' WHERE rowid=$(__call_pkg_rowid ${1})"
    else
        return 1
    fi
} 

__call_pkg_name() {
    if $(__check_pkg "${1}") ; then
        sqlite3 "${themis_db}" "SELECT pkg FROM packages WHERE pkg LIKE '${1}' LIMIT 1"
    else
        return 1
    fi
}

__call_pkg_ver() {
    case "${1}" in
        pkgs|packages|-pkgs)
            if $(__check_pkg "${2}") ; then
                sqlite3 "${themis_db}" "SELECT pkg, ver FROM packages WHERE pkg LIKE '${2}'"
            else
                return 1
            fi
        ;;
        *)
            if $(__check_pkg "${1}") ; then
                sqlite3 "${themis_db}" "SELECT ver FROM packages WHERE pkg LIKE '${1}' LIMIT 1"
            else
                return 1
            fi
        ;;
    esac
}

__call_pkg_maintainer() {
    if $(__check_pkg "${1}") ; then
        sqlite3 "${themis_db}" "SELECT maintainer FROM packages WHERE pkg LIKE '${1}' LIMIT 1"
    else
        echo "no-body"
    fi
}

__call_pkg_description() {
    if $(__check_pkg "${1}") ; then
        sqlite3 "${themis_db}" "SELECT desc FROM packages WHERE pkg LIKE '${1}' LIMIT 1"
    else
        echo "no-description"
    fi
}

__call_pkg_codec() {
    if $(__check_pkg "${1}") ; then
        sqlite3 "${themis_db}" "SELECT codec FROM packages WHERE pkg LIKE '${1}' LIMIT 1"
    else
        return 1
    fi
}

# Utils
__update_pkg() {
    case "${1}" in
       [vV][eE][rR][sS][iI][oO][nN]|[vV][eE][rR])
           # The Function    pkg  new version
           __up_opt="ver"
        ;;
        *)
            __up_opt=""
        ;;
    esac
    if [[ ! -z ${__up_opt} ]] ; then
        sqlite3 "${themis_db}" "UPDATE package SET ${__up_opt} = '${2}' WHERE rowid=$(__call_pkg_rowid ${1})"
    else
        return 1
    fi
}