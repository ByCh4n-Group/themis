#!/bin/bash

set -e

# execute this script in directory "themis"

# mv $(tar -xvf basic-modules/color-1.0.0.tar.gz ./CONTROL) aa

[ $UID != 0 ] && { echo "Please Run It As Root Privalages. 'sudo bash $0'" ; exit 1 ; }

user="${SUDO_USER:-$USER}"
group=$(cat /etc/group | awk -F: '{ print $1}' | grep -w ${user} || echo "users")

_install() {
    # Preparing installation place
    mkdir -p /usr/local/lib/themis /usr/share/themis/repositories /usr/share/themis/packages /usr/share/licenses/themis /usr/share/doc/themis

    # Copying files
    ## cp ./completion/themis.sh /etc/bash_completion.d
    cp -r ./doc/* ./README.md /usr/share/doc/themis
    cp ./LICENSE /usr/share/licenses/themis
    cp ./themis.conf ./repo.sh /usr/share/themis

    # Install the triggers
    install -m 755 ./lib/*.sh /usr/local/lib/themis
    install -m 755 ./yap.sh /bin/yap
    install -m 755 ./themis.sh /bin/themis

    # Set up db
    sqlite3 "/usr/share/themis/packages.db" "CREATE TABLE packages(pkg TEXT,ver TEXT,maintainer TEXT,desc TEXT,codec TEXT)"
    openssl genrsa -out "/usr/share/themis/priv.pem" 2048
    openssl rsa -in "/usr/share/themis/priv.pem" -outform PEM -pubout -out "/usr/share/themis/pub.pem"

    # last touch
    chmod 755 /usr/share/themis/*
}

_uninstall() {
    rm -rf /usr/local/lib/themis /usr/share/themis /usr/share/licenses/themis /usr/share/doc/themis /etc/bash_completion.d/themis.sh /bin/themis /bin/yap
}

case ${1} in
    [cC][aA][lL][lL]|--[cC][aA][lL][lL]|-[cC])
        case ${2} in
            [gG][rR][oO][uU][pP]|--[gG][rR][oO][uU][pP]|-[gG])
                echo "${group}"
            ;;
            [uU][sS][eE][rR]|--[uU][sS][eE][rR]|-[uU])
                echo "${user}"
            ;;
            *)
                echo "${user}"
            ;;
        esac
    ;;
    [iI][nN][sS][tT][aA][lL][lL]|--[iI][nN][sS][tT][aA][lL][lL]|-[iI])
        _install
        echo "installation completed."
    ;;
    [uU][nN][iI][nN][sS][tT][aA][lL][lL]|--[uU][nN][iI][nN][sS][tT][aA][lL][lL]|-[uU])
        _uninstall
        echo "uninstallation completed."
    ;;
    [rR][eE][iI][nN][sS][tT][aA][lL][lL]|--[rR][eE][iI][nN][sS][tT][aA][lL][lL]|-[rR])
        _uninstall && _install
        echo "reinstallation completed."
    ;;
    *)
        echo -e "Wrong Usage There Are Three (3) Flags: --install,--uninstall,--reinstall"
        exit 1
    ;;
esac
