#!/bin/bash

__makepackage() {
    ########
    # Head #
    ########

    setdir="${PWD}"    
    package=""
    version=""
    maintainer=""
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
        for i in $(seq 1 ${#}) ; do
            ######################
            #         Main       #
            ######################
            cd ${setdir}
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
                            
                            # Bağımlımısın kardeş?
                            if [[ ! -z ${dependencies[@]} ]] ; then
                                found "${#dependencies[@]} themis dependencie(s)"
                            fi
                            
                            # Debian
                            if [[ ! -z ${debian_depends[@]} ]] ; then
                                found "${#debian_depends[@]} debian dependencie(s)"
                            fi
               
                            # Arch
                            if [[ ! -z ${arch_depends[@]} ]] ; then
                                found "${#arch_depends[@]} arch dependencie(s)"
                            fi
                            
                            # Demo AUR
                            if [[ ! -z ${aur_depends[@]} ]] ; then
                                found "${#aur_depends[@]} arch user repository dependencie(s)"
                            fi

                            # Fedora
                            if [[ ! -z ${fedora_depends[@]} ]] ; then
                                found "${#fedora_depends[@]} fedora dependencie(s)"
                            fi
                            
                            # Pisi
                            if [[ ! -z ${pisi_depends[@]} ]] ; then
                                found "${#pisi_depends[@]} pisi dependencie(s)"
                            fi
                            
                            # OpenSUS
                            if [[ ! -z ${opensuse_depends[@]} ]] ; then
                                found "${#opensuse_depends[@]} opensuse dependencie(s)"
                            fi
                            
                            # Python3
                            if [[ ! -z ${python3_depends[@]} ]] ; then
                                found "${#python3_depends[@]} python3 required module(s)"
                            fi
                            
                            # Ruby(Gem)
                            if [[ ! -z ${ruby_depends[@]} ]] ; then
                                found "${#ruby_depends[@]} ruby required module(s)"
                            fi

                            # Postinst script
                            if [[ -f "${@:i:1}/post-inst.sh" ]] ; then
                                found "post-inst script"
                            fi

                            # Debian Postins script
                            if [[ -f "${@:i:1}/post-debian.sh" ]] ; then
                                found "post-inst script for debian"
                            fi

                            # Arch Postins script
                            if [[ -f "${@:i:1}/post-arch.sh" ]] ; then
                                found "post-inst script for arch"
                            fi

                            # Fedora Postins script
                            if [[ -f "${@:i:1}/post-fedora.sh" ]] ; then
                                found "post-inst script for fedora"
                            fi

                            # Pisi Postins script
                            if [[ -f "${@:i:1}/post-pisi.sh" ]] ; then
                                found "post-inst script for pisi"
                            fi

                            # OpenSUSE Postins script
                            if [[ -f "${@:i:1}/post-opensuse.sh" ]] ; then
                                found "post-inst script for opensuse"
                            fi

                            # Lisans
                            if [[ -f LICENSE ]] ; then
                                found "License"
                            fi

                            # ReadMe
                            if [[ -f README* ]] ; then
                                found "ReadMe File"
                            fi

                            # Docs
                            if [[ -d doc ]] && [[ $(ls ./doc/*) -gt 0 ]] ; then
                                found "Documentation(s)"
                            fi

                            # Build fonksyonu kontrol
                            if [[ $(grep "build() {" "${@:i:1}/CONTROL") ]] ; then
                                cd ${@:i:1}
                                tar -czf ${setdir}/${package}-${version}.themis ./* && success "The package ${package} has compiled" || { error "The package can not be created in ${setdir}" ; stat="false" ; }
                                printf "${Bgreen}"
                                centex "Created ${setdir}/${package}-${version}.tar.gz."
                                printf "${reset}\n"
                                # Paketi sıkıştırma
                            else
                                status="false"
                                notfound "Fatal: build function not found!"
                                # Build fonksyonu kontrol
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
                        error "variable package can not be null and you can't use spaces in pacakge names"
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
        error "you need to give some parametre(s)"
        # parametre girmelisin
    fi

    ########
    # Tail #
    ########

    if [[ ${status} = "false" ]] ; then
        error "Some package(s) can not be creared" "2"
    else
        success "${FUNCNAME} has completed and no error(s) occured"
    fi

    ###########
    ####END####
    ###########
}