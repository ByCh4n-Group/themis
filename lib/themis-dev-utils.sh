#!/bin/bash

__makepackage() {
    ########
    # Head #
    ########

    tos_check_opt="exit"
    check t "tar" "base64"

    setdir="${PWD}"   
    package=""
    version=""
    maintainer=""
    is_arch=""
    description=""
    dependencies=""
    debian_depends=""
    arch_depends=""
    aur_depends=""
    fedora_depends=""
    pisi_depends=""
    opensuse_depends=""
    python3_depends=""
    ruby_depends=""

    ########
    # Body #
    ########

    if [[ ${#} -ge 1 ]] ; then
        status="true"
        echo ""
        for i in $(seq 1 ${#}) ; do
            ######################
            #         Main       #
            ######################
            cd ${setdir}
            build() { 
                cat > ${pkdir}yapfile 
            }
            printf "${Bcyan}"
            centex "Checking ${@:i:1}.."
            printf "${reset}"
            if [[ -d "${@:i:1}" ]] ; then
                if [[ -e "${@:i:1}/CONTROL" ]] && source "${@:i:1}/CONTROL" ; then
                    # Paket ismi kontrol
                    if ! [[  -z ${package} ]] && [[ $(echo "${package}" | grep " ") = "" ]] ; then
                        # version kontrol
                        if [[ ! -z ${version} ]] ; then
                            # Diğer pekte gereği olmayan metadata kontrol
                            [[ -z ${maintainer} ]] && maintainer="anybody"
                            [[ -z ${description} ]] && description="you already know what to do ;)"
                            
                            # set arch?
                            if [[ ! -z "${is_arch}" ]] ; then
                                found "specific architecture found '${is_arch}' it will be check in the installation"
                            fi
                            # Bağımlımısın kardeş?
                            if [[ ! -z ${dependencies[@]} ]] ; then
                                found "${#dependencies[@]} themis dependencie(s)"
                                grep -w "dependencies=" "${@:i:1}/CONTROL" > "${@:i:1}/DEPENDS"
                            fi
                            
                            # Debian
                            if [[ ! -z ${debian_depends[@]} ]] ; then
                                found "${#debian_depends[@]} debian dependencie(s)"
                                grep -w "debian_depends=" "${@:i:1}/CONTROL" >> "${@:i:1}/OS_DEPENDS"
                            fi
               
                            # Arch
                            if [[ ! -z ${arch_depends[@]} ]] ; then
                                found "${#arch_depends[@]} arch dependencie(s)"
                                grep -w "arch_depends=" "${@:i:1}/CONTROL" >> "${@:i:1}/OS_DEPENDS"
                            fi
                            
                            # Demo AUR
                            if [[ ! -z ${aur_depends[@]} ]] ; then
                                found "${#aur_depends[@]} arch user repository dependencie(s)"
                                grep -w "aur_depends=" "${@:i:1}/CONTROL" >> "${@:i:1}/OS_DEPENDS"
                            fi

                            # Fedora
                            if [[ ! -z ${fedora_depends[@]} ]] ; then
                                found "${#fedora_depends[@]} fedora dependencie(s)"
                                grep -w "fedora_depends=" "${@:i:1}/CONTROL" >> "${@:i:1}/OS_DEPENDS"
                            fi
                            
                            # Pisi
                            if [[ ! -z ${pisi_depends[@]} ]] ; then
                                found "${#pisi_depends[@]} pisi dependencie(s)"
                                grep -w "pisi_depends=" "${@:i:1}/CONTROL" >> "${@:i:1}/OS_DEPENDS"
                            fi
                            
                            # OpenSUS
                            if [[ ! -z ${opensuse_depends[@]} ]] ; then
                                found "${#opensuse_depends[@]} opensuse dependencie(s)"
                                grep -w "opensuse_depends=" "${@:i:1}/CONTROL" >> "${@:i:1}/OS_DEPENDS"
                            fi
                            
                            ### Extra Modules ###
                            ## Python3
                            #if [[ ! -z ${python3_depends[@]} ]] ; then
                            #    found "${#python3_depends[@]} python3 required module(s)"
                            #    for pyreq in $(seq 0 "${#python3_depends[@]}") ; do
                            #        echo "${python3_depends[$pyreq]}" >> "${@:i:1}/requirements.txt"    
                            #    done
                            #fi
                            
                            ## Ruby(Gem)
                            #if [[ ! -z ${ruby_depends[@]} ]] ; then
                            #    found "${#ruby_depends[@]} ruby required module(s)"
                            #    for gemfile in $(seq 0 "${#ruby_depends[@]}") ; do
                            #        echo "${ruby_depends[$gemfile]}" >> "${@:i:1}/gemfile"    
                            #    done
                            #fi
                            ### Extra Modules ###

                            # Postinst script
                            if [[ -f "${@:i:1}/post-inst.sh" ]] ; then
                                found "post-inst script"
                            fi

                            # Debian Postinst script
                            if [[ -f "${@:i:1}/post-debian.sh" ]] ; then
                                found "post-inst script for debian"
                            fi

                            # Arch Postinst script
                            if [[ -f "${@:i:1}/post-arch.sh" ]] ; then
                                found "post-inst script for arch"
                            fi

                            # Fedora Postinst script
                            if [[ -f "${@:i:1}/post-fedora.sh" ]] ; then
                                found "post-inst script for fedora"
                            fi

                            # Pisi Postinst script
                            if [[ -f "${@:i:1}/post-pisi.sh" ]] ; then
                                found "post-inst script for pisi"
                            fi

                            # OpenSUSE Postinst script
                            if [[ -f "${@:i:1}/post-opensuse.sh" ]] ; then
                                found "post-inst script for opensuse"
                            fi

                            # preinst script
                            if [[ -f "${@:i:1}/pre-inst.sh" ]] ; then
                                found "pre-inst script"
                            fi

                            # Debian preinst script
                            if [[ -f "${@:i:1}/pre-debian.sh" ]] ; then
                                found "pre-inst script for debian"
                            fi

                            # Arch preinst script
                            if [[ -f "${@:i:1}/pre-arch.sh" ]] ; then
                                found "pre-inst script for arch"
                            fi

                            # Fedora preinst script
                            if [[ -f "${@:i:1}/pre-fedora.sh" ]] ; then
                                found "pre-inst script for fedora"
                            fi

                            # Pisi preinst script
                            if [[ -f "${@:i:1}/pre-pisi.sh" ]] ; then
                                found "pre-inst script for pisi"
                            fi

                            # OpenSUSE preinst script
                            if [[ -f "${@:i:1}/pre-opensuse.sh" ]] ; then
                                found "pre-inst script for opensuse"
                            fi

                            # Lisans
                            if [[ -f "${@:i:1}/LICENSE" ]] ; then
                                found "License"
                            fi

                            # ReadMe
                            if [[ -f "${@:i:1}"/README* ]] ; then
                                found "ReadMe File"
                            fi

                            # Docs
                            if [[ -d "${@:i:1}/doc" ]] && [[ $(ls ${@:i:1}/doc/*) -gt 0 ]] &> /dev/null ; then
                                found "Documentation(s)"
                            fi

                            # yap yönlendirmesi kontrol
                            if [[ $(grep "build <<YAP" "${@:i:1}/CONTROL") ]] ; then
                                cd "${@:i:1}"
                                mv "${setdir}/yapfile" ./ 
                                cat ./yapfile | base64 > yapfile64
                                echo -e "package='${package}'\nversion='${version}'" > ./METADATA
                                [[ ! -z ${maintainer} ]] && echo "maintainer='${maintainer}'" >> ./METADATA  
                                [[ ! -z ${description} ]] && echo "description='${description}'" >> ./METADATA
                                [[ ! -z ${is_arch} ]] && echo "is_arch='${is_arch}'" >> ./METADATA
                                tar -czf ${setdir}/${package}-${version}.themis ./* && success "The package ${package} has compiled" || { error "The package can not be created in ${setdir}" ; stat="false" ; }
                                rm METADATA DEPENDS yapfile yapfile64 requirements.txt OS_DEPENDS &> /dev/null
                                printf "${Bgreen}"
                                centex "created ${setdir}/${package}-${version}.themis"
                                printf "${reset}\n"
                                # Paketi sıkıştırma
                            else
                                status="false"
                                notfound "Fatal: build reference for yapfile definition is not found!"
                                
                                # yap yönlendirmesi kontrol
                                printf "${Bred}"
                                centex "Failed ${@:i:1}."    
                                printf "${reset}\n"
                            fi
                        else
                            status="false"
                            notfound 'variable ${version} can not be null'
                            # version değişkeni boş olamaz
                            printf "${Bred}"
                            centex "Failed ${@:i:1}."
                            printf "${reset}\n"
                        fi
                    else
                        status="false"
                        error 'variable ${package} can not be null and you can not use spaces in pacakge names'
                        # paket ismi boş yada boşluklu olamaz
                        printf "${Bred}"
                        centex "Failed ${@:i:1}."
                        printf "${reset}\n"
                    fi
                else
                    status="false"
                    notfound "i can't find the 'CONTROL' file is that themis package?"
                    # bu bir themis paketi mi?
                    printf "${Bred}"
                    centex "Failed ${@:i:1}."   
                    printf "${reset}\n"
                fi
            else
                status="false"
                error "hmm that is not a directory"
                # bu bir dizin değil 
                printf "${Bred}"
                centex "Failed ${@:i:1}."
                printf "${reset}\n"
            fi
            ######################
        done
    else
        status="false"
        error "you need to give some parametre(s) as package directory."
        # parametre girmelisin
    fi

    ########
    # Tail #
    ########

    if [[ ${status} = "false" ]] ; then
        error "Some package(s) can not be creared." "2"
    else
        success "${FUNCNAME} has completed and no error(s) occured"
    fi

    ###########
    ####END####
    ###########
}

__makerepo() {
    getlib "opnsslkm" "btb"
    check t "tar"
    _req4opnsslkm
    btb-create-bank "index"
    # Buraya belki .themis uzantılı dosyalar yerine gzip dosyalarını bulma getirilebilir.
    for x in $(find . -type f | sed 's/^//' | grep ".themis") ; do
        package=""
        version=""
        maintainer=""
        if [[ $(tar -ztf ${x} | grep -w "./CONTROL") ]] &> /dev/null ; then
            tar -zxf "${x}" "./METADATA" && source METADATA
            if [[ ! $(btb-call-index "index.btb" -lb | grep "${package}/" ) ]] &> /dev/null ; then
                btb-create-base "index.btb" "${package}"
                if [[ "${1}" = "true" ]] ; then
                    __sif "${x}"
                fi
                btb-write-data "index.btb" "${package}" "path" "$(echo "${x}" | sed 's/^.//')"
                [[ -f $(find . -type f | grep "${x}.sha256") ]] && btb-write-data "index.btb" "${package}" "signature" "$(cat $(find . -type f | grep ${x}.sha256))"
                btb-write-data "index.btb" "${package}" "version" "${version}"
                btb-write-data "index.btb" "${package}" "maintainer" "${maintainer}"
                if $(tar -ztf ${x} | grep -w "./DEPENDS") &> /dev/null ; then
                    tar -zxf "${x}" "./METADATA" && btb-write-data "index.btb" "${package}" "depends" "$(cat ./DEPENDS)"
                fi
            fi
        fi
    done
    [[ -f METADATA ]] && rm METADATA &> /dev/null
    [[ -f DEPENDS ]] && rm DEPENDS &> /dev/null
    __gen_priv_key && openssl rsa -in "${themis_home}/priv.pem" -outform PEM -pubout -out "pub.pem"
}