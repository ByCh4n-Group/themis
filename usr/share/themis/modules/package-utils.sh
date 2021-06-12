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
                [ -e ${1}/post-inst.sh ] && echo -e "${Bgreen}post-inst.sh${reset} don't forget the post-inst scripts has no return so that is one-way script."
                [ -e ${1}/debian-inst.sh ] && echo -e "${Bgreen}debian-inst.sh${reset} don't forget the post-inst scripts has no return so that is one-way script."
                [ -e ${1}/arch-inst.sh ] && echo -e "${Bgreen}arch-inst.sh${reset} don't forget the post-inst scripts has no return so that is one-way script."
                [ -e ${1}/fedora-inst.sh ] && echo -e "${Bgreen}fedora-inst.sh${reset} don't forget the post-inst scripts has no return so that is one-way script."
                [ -e ${1}/pisi-inst.sh ] && echo -e "${Bgreen}pisi-inst.sh${reset} don't forget the post-inst scripts has no return so that is one-way script." 
                [ -e ${1}/opensuse-inst.sh ] && echo -e "${Bgreen}opensuse-inst.sh${reset} don't forget the post-inst scripts has no return so that is one-way script."
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
}

checkpackage() {
    :
}

installpackage() {
    centexpad "+"

    centexpad "+"
}