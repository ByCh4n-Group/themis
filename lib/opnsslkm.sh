#!/bin/bash

_req4opnsslkm() {
    # Requirements For OpenSSL Key Management
    check t "openssl" "base64"
    [[ -f "${themis_home}/pub.pem" ]] || { fixit -pk || error "private&public keys couldn't creating in this time!" "2"; }
}

__gen_priv_key() {
    if [[ ! -f "${themis_home}/priv.pem" ]] ; then
        checkroot -e
        openssl genrsa -out "${themis_home}/priv.pem" 2048 || return 1
    fi
}

__gen_pub_key() {
    if [[ -f "${themis_home}/priv.pem" ]] ; then
        openssl rsa -in "${themis_home}/priv.pem" -outform PEM -pubout -out "${themis_home}/pub.pem" || return 1
    else
        echo "Please firstly generate the private key. 'openssl genrsa -out "${themis_home}/priv.pem" 2048'"
        return 1
    fi
}

__sif() {
    _req4opnsslkm
    local file="${1}"
    local key="${themis_home}/priv.pem"
    if [[ -f ${key} ]] ; then
        { openssl dgst -sha256 -sign "${key}" -out "/tmp/$(filename ${file}).sha256" "${file}" && openssl base64 -in "/tmp/$(filename ${file}).sha256" -out "$(filename ${file}).sha256" ; } && rm "/tmp/$(filename ${file}).sha256" || return 1
    else
        { __gen_priv_key && { openssl dgst -sha256 -sign "${key}" -out "/tmp/$(filename ${file}).sha256" "${file}" && openssl base64 -in "/tmp/$(filename ${file}).sha256" -out "$(filename ${file}).sha256" ; } ; } && rm "/tmp/$(filename ${file}).sha256" || return 1
    fi
}

__cisf() {
    # Check If Signed File
    local file="${1}"
    local signature="${2}"
    local pkey="${3}"
    { openssl base64 -d -in "${signature}" -out "/tmp/$(filename ${file}).sha256" && openssl dgst -sha256 -verify "${pkey}" -signature "/tmp/$(filename ${file}).sha256" "${file}" ; } && rm "/tmp/$(filename ${file}).sha256" || return 1
}