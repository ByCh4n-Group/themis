#!/bin/bash

## checkroot -e

getlib "opnsslkm" "sqlit3"

__uninstall() {
    if [[ ${#} -ge 1 ]] ; then
        local status="true"
        local setdir="${PWD}"
        
        check t "base64" "yap"
        for y in $(seq 1 ${#}) ; do
            cd "${setdir}"
            if $(__check_pkg ${@:y:1}) ; then
                mkdir -p "${themis_temp}/TRASH" ; cd $_ &> /dev/null
                __call_pkg_codec "${@:y:1}" | base64 -d > yapfile && yap --reverse
                if [[ $? = 0 ]] ; then
                    __delete_pkg "${@:y:1}" && success "${@:y:1} has been removed succesfully." || error "the package ${@:y:1} metada's couldn't removing in this time. Please try it manually ( sqlite3 '${themis_db}' 'DELETE FROM packages WHERE rowid=ID')"
                else
                    local status="false"
                    error "The yap couldn't removing the package ${@:y:1} in this time."
                fi
            else
                local status="false"
                error "The package ${@:y:1} isn't exist so not installed"
            fi
        done
        
        cd "${setdir}"
        
        if [[ "${status}" = "false" ]] ; then
            error "Some packages couldn't un-installed" "2"
        fi        
    else
        cd "${setdir}"
        error "You must enter the file name of the packages you want to un-install." "2"    
    fi
}

__getpackage() {
    :
}

__depresolv() {
    :
}

__comparever_pkg() {
    # METADATA dosyasını source ettikten sonra kullanılabilir
    # . ./METADATA

    pkg_ver=$(__call_pkg_ver ${package})
    
    # mutlak paket değeri
    __set_ver=$(( ( $(echo "${version}" | tr "." " " | awk '{print $1}') * 100 ) + ( $(echo "${version}" | tr "." " " | awk '{print $2}') * 10 ) + $(echo "${version}" | tr "." " " |  awk '{print $3}') ))
    
    # kurulu paket mutlak değeri
    __set_pkg_ver=$(( ( $(echo "${pkg_ver}" | tr "." " " | awk '{print $1}') * 100 ) + ( $(echo "${pkg_ver}" | tr "." " " | awk '{print $2}') * 10 ) +  $(echo "${pkg_ver}" | tr "." " " | awk '{print $3}') ))
    if [[ ${__set_ver} -eq ${__set_pkg_ver} ]] ; then
        echo "="
    elif [[ ${__set_ver} -gt ${__set_pkg_ver} ]] ; then
        echo ">"
    else
        # you can't downgrade this package now
        return 1
    fi
}

__installpackage() {
    if [[ ${#} -ge 1 ]] ; then
    # Defaults
    local status="true"
    local setdir="${PWD}"
    tos_check_opt="exit"
    check t "tar" "yap"
    
    package=""
    version=""
    maintainer=""
    description=""
    is_arch=""

    ___standart_installation() {
        __pre_setup() {
            definebase
            if [[ -f ./OS_DEPENDS ]] ; then 
                source ./OS_DEPENDS
                printf "${cyan}"; centex "operating system dependencies&post-inst scripts triggering" ; printf "${reset}"
                case "${set_systembase}" in
                    debian)
                        [[ ! -z ${#debian_depends[@]} ]] && install-os-pkg  ${debian_depends}
                    ;;
                    arch)
                        [[ ! -z ${#arch_depends[@]} ]] && install-os-pkg ${arch_depends}
                    ;;
                    fedora)
                        [[ ! -z ${#fedora_depends[@]} ]] && install-os-pkg ${fedora_depends}
                    ;;
                    pisi)
                        [[ ! -z ${#pisi_depends[@]} ]] && install-os-pkg ${pisi_depends}
                    ;;
                    opensuse)
                        [[ ! -z ${#opensuse_depends[@]} ]] && install-os-pkg ${opensuse_depends}
                    ;;
                esac
            fi

            if [[ $? = 0 ]] ; then
                if [[ -f pre-*.sh ]] ; then
                    [[ -f pre-inst.sh ]] && bash ./pre-inst.sh
                    case "${set_systembase}" in
                        debian)
                            [[ -f ./pre-debian.sh ]] && bash ./pre-debian.sh
                        ;;
                        arch)
                            [[ -f ./pre-arch.sh ]] && bash ./pre-arch.sh
                        ;;
                        fedora)
                            [[ -f ./pre-fedora.sh ]] && bash ./pre-fedora.sh
                        ;;
                        pisi)
                            [[ -f ./pre-pisi.sh ]] && bash ./pre-pisi.sh
                        ;;
                        opensuse)
                            [[ -f ./pre-opensuse.sh ]] && bash ./pre-opensuse.sh
                        ;;
                    esac
                fi

                if [[ $? = 0 ]] ; then
                    return 0
                else
                    return 1
                fi
            else
                return 1
            fi
        }

        if $(__check_pkg "${package}") ; then
            if [[ $(__comparever_pkg) = "=" ]] ; then
                echo "${package} has already installed with version ${version}"
            elif [[ $(__comparever_pkg) = ">" ]] ; then
                __comparever_pkg &> /dev/null
                info "${package} updating.."
                __pre_setup
                if [[ $? = 0 ]] ; then
                    printf "${cyan}" ; centex "$(which yap) --make" ; printf "${reset}" 
                    { { __uninstall "${package}" && yap --make ; } ; } && __create_pkg "${package}" "${version}" "${maintainer}" "${description}" "$(cat yapfile64)" && success "${package} updated ${pkg_ver} to ${version}" || error "${package} can not updating to new relase in this time"
                else
                    error "The package couldn't updating in this time"
                    return 1
                fi
            else
                echo "you can't downgrade package(s) for now."
                return 1
            fi
        else
            __pre_setup
            if [[ $? = 0 ]] ; then
                printf "${cyan}" ; centex "$(which yap) --make" ; printf "${reset}"
                yap --make && __create_pkg "${package}" "${version}" "${maintainer}" "${description}" "$(cat yapfile64)"
            else
                error "Pre-setup failed. quitting"
                return 1
            fi
        fi
    }

        for x in $(seq 1 ${#}) ; do
            local stage1=""
            cd "${setdir}"
            if [[ -f ${@:x:1} ]] ; then
                if [[ $(file ${@:x:1} | grep "gzip compressed data") ]] && [[ $(tar -ztf ${@:x:1} | grep -w "./CONTROL") ]] ; then
                    stdn="$(filename ${@:x:1} | tr '.' ' ' | awk '{print $1}')" # sub temp dir name
                    mkdir -p "${themis_temp}/packages" 2> /dev/null
                    cp "${@:x:1}" "${themis_temp}/packages"
                    mkdir "${themis_temp}/${stdn}" 2> /dev/null ; cd $_
                    tar -xf "${themis_temp}/packages/$(filename ${@:x:1})" -C "${themis_temp}/${stdn}"
                    source ./METADATA || stage1="false"
                    if [[  ${stage1} != "false" ]]  ; then
                        case "${is_arch}" in
                            [xX]86_64)
                                if [[ $(uname -p) = "x86_64" ]] ; then
                                    ___standart_installation
                                else
                                    local status="false"
                                    error "Your proccessor can not run that's program(s)."
                                fi
                            ;;
                            [xX]86)
                                if [[ $(uname -p) = "x86" ]] || [[ $(uname -p) = "x86_64" ]] ; then
                                    ___standart_installation
                                else
                                    local status="false"
                                    error "Your proccessor can not run that's program(s)."
                                fi
                            ;;
                            [aA][rR][mM])
                                if [[ $(uname -p) = arm* ]] ; then
                                    ___standart_installation
                                else
                                    local status="false"
                                    error "Your proccessor can not run that's program(s)."
                                fi
                            ;;
                            *)
                                ___standart_installation
                            ;;
                        esac
                    else
                        local status="false"
                        error "Couldn't sourcing the METADATA file of ${stdn} in this time"
                    fi
                else
                    local status="false"
                    error "the file ${@:x:1} has not a themis package."
                fi
            else
                local status="false"
                error "What does 2+2=¿"
            fi
        done
        
        if [[ "${status}" = "false" ]] ; then
            error "Some packages couldn't installed" "2"
        fi
    else
        error "You must enter the file path of the packages you want to install." "2"
    fi
}

__install() {
    if [[ ${#} -ge 1 ]] ; then

        local status="true" # her şey tamam
        local setdir="${PWD}"
        tos_check_opt="exit"
        check t "tar"

        for i in $(seq 1 ${#}) ; do
            cd "${setdir}"
            if [[ -f "${@:i:1}" ]] ; then
                __installpackage "${@:i:1}"
            else
                echo "that can be a package from repository!"
            fi
        done 

        if [[ "${status}" = "false" ]] ; then
            error "Some packages couldn't installed" "2"
        fi
    else
        error "You must enter the file path of the packages you want to install." "2"
    fi
}

# kontrol:
#   var ise:
#       sürüm karşılaştır.
#           aynı ise hiç bir şey yapma.
#           yeni ise eskisini sil döngüyü bozmadan kurma işlemine geç.
#   yok ise:
#       kurma işlemi:
#

# Bağımlılık var ise installpackage ve depresolv fonksiyonları bir çalışır