#!/bin/bash

[ $UID != 0 ] && { echo "Please Run It As Root Privalages. 'sudo bash $0'" ; exit 1 ; }

case ${1} in
    [iI][nN][sS][tT][aA][lL][lL])
    ;;
    [uU][nN][iI][nN][sS][tT][aA][lL][lL])
    ;;
    [rR][eE][iI][nN][sS][tT][aA][lL][lL])
    ;;
    *)
        echo -e "Wrong Usage There Are Three (3) Flags:"
        exit 1
    ;;
esac