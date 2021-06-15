#!/bin/bash

makepackage() {
    centexpad "*"
    tarstatus="nice"
    if [ -e ${1}/CONTROL ] ; then
        package=""
        version=""
        maintainer=""
        description=""
        source ${1}/CONTROL && success "CONTROL: File Sourced Successfully"
        if [ ! -z ${package} ] ; then
            success "set package variable is ${green}${package}${reset}"
            if [[ $(grep "build() {" "${1}/CONTROL") ]] ; then
                success "build: function found."
                [ -z ${version} ] && version="1.0.0"
                [[ -z ${maintainer} ]] && maintainer="anyone"
                [[ -z ${description} ]] && description="rtfm"
                [ ! -z ${arch_depends} ] && echo -e "${Bgreen}Arch Linux${reset} dependences found."
                [ ! -z ${debian_depends} ] && echo -e "${Bgreen}Debian Linux${reset} dependences found."
                [ ! -z ${fedora_depends} ] && echo -e "${Bgreen}Fedora Linux${reset} dependences found."
                [ ! -z ${pisi_depends} ] && echo -e "${Bgreen}Pisi Linux${reset} dependences found."
                [ ! -z ${opensuse_depends} ] && echo -e "${Bgreen}OpenSuse Linux${reset} dependences found."
                [ ! -z ${python3_depends} ] && echo -e "${Bgreen}Python3${reset} dependences found."
                [ ! -z ${ruby_depends} ] && echo -e "${Bgreen}Ruby${reset} dependences found."
                [ -e ${1}/debian-inst.sh ] && echo -e "${Bgreen}debian-inst.sh${reset} don't forget the post-inst scripts has no return so that is one-way script."
                [ -e ${1}/arch-inst.sh ] && echo -e "${Bgreen}arch-inst.sh${reset} don't forget the post-inst scripts has no return so that is one-way script."
                [ -e ${1}/fedora-inst.sh ] && echo -e "${Bgreen}fedora-inst.sh${reset} don't forget the post-inst scripts has no return so that is one-way script."
                [ -e ${1}/pisi-inst.sh ] && echo -e "${Bgreen}pisi-inst.sh${reset} don't forget the post-inst scripts has no return so that is one-way script." 
                [ -e ${1}/opensuse-inst.sh ] && echo -e "${Bgreen}opensuse-inst.sh${reset} don't forget the post-inst scripts has no return so that is one-way script."
                [ -e ${1}/post-inst.sh ] && echo -e "${Bgreen}post-inst.sh${reset} don't forget the post-inst scripts has no return so that is one-way script."
                [ -e ${1}/LICENSE ] && echo -e "${Bgreen}License${reset}: LICENSE file found. This file will be added to your package of metadata directory."
                { [ -e ${1}/README ] || [ -e ${1}/README.* ] ; } && echo -e "${Bgreen}Readme${reset}: README or README.<format> file found. This file will be added to your package of metadata directory."
                echo -e "package: ${Byellow}${package}${reset}\nversion: ${Byellow}${version}${reset}\nmaintainer: ${Byellow}${maintainer}${reset}\ndescription: ${Byellow}${description}${reset}"
                ascii-art "turtle"
                cd ${1}
                tar -czvf ${setdir}/${package}_${version}.tar.gz ./* && success "the package has been saved: ${Bblue}${setdir}/${package}_${version}.tar.gz${reset}" 
                cd ${setdir}
            else
                error "build function not found!"
                tarstatus="bad"
                status="bad"
            fi
        else
            error "package: That Variable Can Not Be Null"
            tarstatus="bad"
            status="bad"
        fi
    else
        error "CONTROL: MetaData File Not Found!"
        tarstatus="bad"
        status="bad"
    fi
    [[ ${tarstatus} = "bad" ]] && error "${1}: That Directory Can Not Be Compressed." || [[ ${tarstatus} = "nice" ]] && echo -e "${Bgreen}The Package Compressed Successfully.${reset}"
    centexpad "*"
    echo -e "${reset}"
}

installpackage() {
    [ -d /tmp/themis/cache/pkg ] || mkdir -p /tmp/themis/cache/pkg 
    centexpad "+"
    cp ${1} /tmp/themis/cache/pkg
    cd /tmp/themis/cache/pkg
    tar -xf ${2} && rm ${2}
    if [ -e CONTROL ] ; then
        package=""
        version=""
        maintainer=""
        description=""
        source CONTROL
        [[ -z ${version} ]] && version="1.0.0"
        [[ -z ${maintainer} ]] && maintainer="anyone"
        [[ -z ${description} ]] && description="rtfm"
        if [[ ! -z ${package} ]] ; then
            if [ -d ${pkgmd} ] ; then
                if [[ ! -d ${pkgmd}/${package} ]] ; then
                    # ========================= aha bak buraya işte build'in içine girilecek fonksyonlar tanımlanacak ===========================
                    basedir() {
                        if [ ${#} -gt 0 ] ; then
                            for y in $(seq 1 ${#}) ; do
                                [ -d ${@:y:1} ] && warn "${@:y:1}: directory already exist" || mkdir -p ${@:y:1}
                            done
                        else
                            return 1
                        fi
                    }
                    move() {
                        if [[ ! -z ${1} ]] && [[ ! -z ${2} ]] ; then
                            if [ -e ${1} ] ; then
                                    cp -r ${1} ${2} && success "${1} -> ${2}"
                                    chown -R ${user}:${group} ${2}/${1}
                                    [ -e ${2}/${1} ] && chmod +x ${2}/${1}
                            else
                                error "directory or file doesn't exist"
                                return 1
                            fi
                        else
                            error "please specify the directory or file and target"
                            return 1
                        fi 
                    }
                    # ===========================================================================================================================
                    centex "dependences & post-inst scripts"
                    dependstatus="nice"
                    postinststatus="nice"
                    definebase
                    case ${set_systembase} in
                        debian)
                            [[ ! -z ${debian_depends[@]} ]] && { installpkg "${debian_depends[@]}" && dependstatus="nice" || dependstatus="bad" ; } || { warn "debian based distro found but no dependences given" && dependstatus="nice" ; }
                            if [[ ${dependstatus} = "nice" ]] ; then
                                if [ -e debian-inst.sh ] ; then
                                    bash debian-inst.sh && { success "debian-inst script has executed." && postinststatus="nice" ; } || { error "debian-inst script can not be executing." && postinststatus="bad" ; }
                                fi
                            fi
                        ;;
                        arch)
                            [[ ! -z ${arch_depends[@]} ]] && { installpkg "${arch_depends[@]}" && dependstatus="nice" || dependstatus="bad" ; } || { warn "arch based distro found but no dependences given" && dependstatus="nice" ; }
                            if [[ ${dependstatus} = "nice" ]] ; then
                                if [ -e arch-inst.sh ] ; then
                                    bash arch-inst.sh && { success "arch-inst script has executed." && postinststatus="nice" ; } || { error "arch-inst script can not be executing." && postinststatus="bad" ; }
                                fi
                            fi
                        ;;
                        fedora)
                            [[ ! -z ${fedora_depends[@]} ]] && { installpkg "${fedora_depends[@]}" && dependstatus="nice" || dependstatus="bad" ; } || { warn "fedora based distro found but no dependences given" && dependstatus="nice" ; }
                             if [[ ${dependstatus} = "nice" ]] ; then
                                if [ -e fedora-inst.sh ] ; then
                                    bash fedora-inst.sh && { success "fedora-inst script has executed." && postinststatus="nice" ; } || { error "fedora-inst script can not be executing." && postinststatus="bad" ; }
                                fi
                            fi
                        ;;
                        pisi)
                            [[ ! -z ${pisi_depends[@]} ]] && { installpkg "${pisi_depends[@]}" && dependstatus="nice" || dependstatus="bad" ; } || { warn "pisi based distro found but no dependences given" && dependstatus="nice" ; }
                            if [[ ${dependstatus} = "nice" ]] ; then
                                if [ -e pisi-inst.sh ] ; then
                                    bash pisi-inst.sh && { success "pisi-inst script has executed." && postinststatus="nice" ; } || { error "pisi-inst script can not be executing." && postinststatus="bad" ; }
                                fi
                            fi
                        ;;
                        opensuse)
                            [[ ! -z ${opensuse_depends[@]} ]] && { installpkg "${opensuse_depends[@]}" && dependstatus="nice" || dependstatus="bad" ; } || { warn "opensuse based distro found but no dependences given" && dependstatus="nice" ; }
                            if [[ ${dependstatus} = "nice" ]] ; then
                                if [ -e opensuse-inst.sh ] ; then
                                    bash opensuse-inst.sh && { success "opensuse-inst script has executed." && postinststatus="nice" ; } || { error "opensuse-inst script can not be executing." && postinststatus="bad" ; }
                                fi
                            fi
                        ;;
                    esac

                    if [[ ${dependstatus} = "nice" ]] ; then
                        if [[ ${postinststatus} = "nice" ]]  ; then
                            buildstatus="nice"
                            if [[ ! -z ${python3_depends[@]} ]] ; then
                                checkdepedns "python3" "pip3"
                                netcheck "e"
                                pip3 install "${python3_depends[@]}" && success "python3 depends are installed" || { error "python3 dependeces found but not installed!" && buildstatus="bad"; }
                            fi

                            if [[ ! -z ${ruby_depends[@]} ]] ; then
                                checkdepedns "ruby" "gem"
                                netcheck "e"
                                gem install "${ruby_depends[@]}" && success "ruby depends are installed" || { error "ruby dependeces found but not installed!" && buildstatus="bad"; }
                            fi

                            if [ -e post-inst.sh ] ; then
                                bash post-inst.sh && success "post-inst script executed successfully" || { error "pos-inst script found but error encountered during execution!" && buildstatus="bad"; }
                            fi
                            
                            if [[ ${buildstatus} = "nice" ]] ; then
                                metadatastatus="nice"
                                centex "build"
                                build && success "${package}: has builded successfully." || { error "${package}: Dependencies and post-inst scripts were installed successfully, but an error was encountered during the build, most likely\n the wrong code was written during the package build. Please contact the maintainer of the package: ${maintainer}\nIn this case, the best thing you can do is to download the package and review the build function in the CONTROL file." ; metadatastatus="bad" ; }
                                if [[ ${metadatastatus} = "nice" ]] ; then
                                    centex "set up metadata"
                                    [ -d ${pkgmd}/${package} ] && rm -rf ${pkgmd}/${package}
                                    mkdir ${pkgmd}/${package} && success "metadata directory has created"
                                    [ -e CONTROL ] && cp ./CONTROL ${pkgmd}/${package} || error "¿taşşak mi geçiyorsun canim?" "e"
                                    [ -e LICENSE ] && { cp ./LICENSE ${pkgmd}/${package} && success "License found and copied" ; }
                                    [ -e README.* ] && { cp ./README.* ${pkgmd}/${package} && success "Readme file(s) found and copied" ; }
                                    ascii-art "sleepcat"
                                    echo -e "package: ${Byellow}${package}${reset}\nversion: ${Byellow}${version}${reset}\nmaintainer: ${Byellow}${maintainer}${reset}\ndescription: ${Byellow}${description}${reset}"
                                    success "The operation completed and no fatal error was encountered."
                                elif [[ ${metadatastatus} = "bad" ]] ; then
                                    error "${package} Version ${version} is faulty and could not be installed some dependencies and post-inst scripts may have been installed please check with the maintainer of the package: ${maintainer}"
                                    status="bad"
                                fi 
                            elif [[ ${buildstatus} == "bad" ]] ; then
                                error "some module(s) or post-inst script(s) can not be installed"
                                status="bad"
                            fi
                        elif [[ ${postinststatus} = "bad" ]] ; then
                            error "post-inst script found and triggered for ${set_systembase} but it returned negative result please contact the maintainer of package: ${maintainer}"
                            status="bad"
                        fi
                    elif [[ ${dependstatus} = "bad" ]] ; then
                        error "Some dependece(s) found for ${set_systembase} but not installed! Please check that packages!"
                        status="bad"
                    fi
                else
                    error "${package}: that package already installed please before remove than try install again."
                    status="bad"
                fi
            else
                error "Packages Of MetaData Directory Not Found Please Check: ${pkgmd}"
                status="bad"
            fi
        else
            error "package: that variable can not be null!"
            status="bad"
        fi
    else
        error "CONTROL: MetaData File Not Found!"
        status="bad"
    fi
    rm -rf /tmp/themis/cache/pkg
    [[ ${inststatus} = "bad" ]] && error "Some Package(s) Can Not Be Installed."
    centexpad "+"
    echo -e "${reset}"
}

uninstallpackage() {
    centexpad "-"
    removestatus="nice"
    if [ -e "${1}/CONTROL" ] ; then
        package=""
        version=""
        maintainer=""
        description=""
        source "${1}/CONTROL"
        # aha bak buraya işte build'İn için de ki kurulum yapacak olan fonksyonların tersine mühendislik uygulanmış hali tanımlanacak
        basedir() {
            if [ ${#} -gt 0 ] ; then
                for y in $(seq 1 ${#}) ; do
                    [ -d ${@:y:1} ] && { rm -rf ${@:y:1} ; success "${@:y:1} -> /dev/null" ; } || warn "${@:y:1}: directory already removed"
                done
            fi
        }
        move() {    
            if [[ ! -z ${1} ]] && [[ ! -z ${2} ]] ; then
                [ -e ${2}/${1} ] && { rm ${2}/${1} ; success "${2}/${1} -> /dev/null" ; } || warn "${1}: that file is already removed"
            else
                error "file or director(y/ies) not specified"
                removestatus="bad"
            fi
        }
        # ===========================================================================================================================
        build && success "file(s) and directory or directories removed" || { error "function(build) is defined incorrectly" ; removestatus="bad" ; }
        if [[ ${removestatus} = "nice" ]] ; then
            echo -e "${Byellow}"
            ascii-art "crown"
            echo -e "${reset}maintainer the ${Bblue}${maintainer}${reset} thanks you for use ${Bblue}${package}${reset} Version ${Bblue}${version}${reset}"
            rm -rf "${1}" && success "${package}: that package has removed successfully" || echo "¿taşşak mı geçiyorsun canim?"
        elif [[ ${removestatus} = "bad" ]] ; then
            error "error(s) occured while proccessing build function and that package not removed"
            status="bad"
        fi
    else
        echo -e "${red}"
        ascii-art "amogus"
        error "hMMM I think the metadata files have been manually modified, but this has corrupted the system."
        status="bad"
    fi
    centexpad "-"
    echo -e "${reset}"
}