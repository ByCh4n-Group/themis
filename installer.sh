#!/bin/bash

# mv $(tar -xvf basic-modules/color-1.0.0.tar.gz ./CONTROL) aa

[ $UID != 0 ] && { echo "Please Run It As Root Privalages. 'sudo bash $0'" ; exit 1 ; }

user="${SUDO_USER:-$USER}"
group=$(cat /etc/group | awk -F: '{ print $1}' | grep -w ${user} || echo "users")

case ${1} in
    [iI][nN][sS][tT][aA][lL][lL]|--[iI][nN][sS][tT][aA][lL][lL]|-[iI])
        echo "installation completed."
    ;;
    [uU][nN][iI][nN][sS][tT][aA][lL][lL]|--[uU][nN][iI][nN][sS][tT][aA][lL][lL]|-[uU])
        echo "uninstallation completed."
    ;;
    [rR][eE][iI][nN][sS][tT][aA][lL][lL]|--[rR][eE][iI][nN][sS][tT][aA][lL][lL]|-[rR])
        echo "reinstallation completed."
    ;;
    *)
        echo -e "Wrong Usage There Are Three (3) Flags: --install,--uninstall,--reinstall"
        exit 1
    ;;
esac