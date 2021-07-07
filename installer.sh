#!/bin/bash

[ $UID != 0 ] && { echo "Please Run It As Root Privalages. 'sudo bash $0'" ; exit 1 ; }

user="${SUDO_USER:-$USER}"
group=$(cat /etc/group | awk -F: '{ print $1}' | grep -w ${user} || echo "users")

case ${1} in
    [iI][nN][sS][tT][aA][lL][lL]|--[iI][nN][sS][tT][aA][lL][lL]|-[iI])
        [ -e ./usr/bin/themis.sh ] && cp ./usr/bin/themis.sh /usr/bin/themis
        [ -e ./etc/bash_completion.d/themis.sh ] && cp ./etc/bash_completion.d/themis.sh /etc/bash_completion.d
        [ -e ./usr/share/doc/packages/themis/README.md ] && { mkdir -p /usr/share/doc/packages/themis && cp ./usr/share/doc/packages/themis/README.md /usr/share/doc/packages/themis ; } 
        [ -e ./usr/share/licences/themis/LICENSE ] && { mkdir -p /usr/share/licences/themis && cp ./usr/share/licences/themis/LICENSE /usr/share/licences/themis ; }
        [ -d ./usr/share/themis ] && cp -r ./usr/share/themis /usr/share
        [ -d /usr/share/themis/packages ] || mkdir -p /usr/share/themis/packages
        [ -d /usr/share/themis/repositories ] || mkdir -p /usr/share/themis/repositories 
        chown -R ${user}:${group} /usr/share/themis/*/*
        echo "installation completed."
    ;;
    [uU][nN][iI][nN][sS][tT][aA][lL][lL]|--[uU][nN][iI][nN][sS][tT][aA][lL][lL]|-[uU])
        [ -e /usr/bin/themis ] && rm /usr/bin/themis
        [ -e /etc/bash_completion.d/themis.sh ] && rm /etc/bash_completion.d/themis.sh
        [ -d /usr/share/themis ] && rm -rf /usr/share/themis
        [ -d /usr/share/doc/packages/themis ] && rm -rf /usr/share/doc/packages/themis
        [ -e /usr/share/licences/themis ] && rm -rf /usr/share/licences/themis 
        echo "uninstallation completed."
    ;;
    [rR][eE][iI][nN][sS][tT][aA][lL][lL]|--[rR][eE][iI][nN][sS][tT][aA][lL][lL]|-[rR])
        [ -e /usr/bin/themis ] && rm /usr/bin/themis
        [ -e /etc/bash_completion.d/themis.sh ] && rm /etc/bash_completion.d/themis.sh
        [ -d /usr/share/themis ] && rm -rf /usr/share/themis
        [ -d /usr/share/doc/packages/themis ] && rm -rf /usr/share/doc/packages/themis
        [ -e /usr/share/licences/themis ] && rm -rf /usr/share/licences/themis 
        [ -e ./usr/bin/themis.sh ] && cp ./usr/bin/themis.sh /usr/bin/themis
        [ -e ./etc/bash_completion.d/themis.sh ] && cp ./etc/bash_completion.d/themis.sh /etc/bash_completion.d
        [ -e ./usr/share/doc/packages/themis/README.md ] && { mkdir -p /usr/share/doc/packages/themis && cp ./usr/share/doc/packages/themis/README.md /usr/share/doc/packages/themis ; } 
        [ -e ./usr/share/licences/themis/LICENSE ] && { mkdir -p /usr/share/licences/themis && cp ./usr/share/licences/themis/LICENSE /usr/share/licences/themis ; }
        [ -d ./usr/share/themis ] && cp -r ./usr/share/themis /usr/share
        [ -d /usr/share/themis/packages ] || mkdir -p /usr/share/themis/packages
        [ -d /usr/share/themis/repositories ] || mkdir -p /usr/share/themis/repositories 
        chown -R ${user}:${group} /usr/share/themis/*/*
        echo "reinstallation completed."
    ;;
    *)
        echo -e "Wrong Usage There Are Three (3) Flags: --install,--uninstall,--reinstall"
        exit 1
    ;;
esac