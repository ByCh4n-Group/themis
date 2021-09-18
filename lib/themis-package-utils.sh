#!/bin/bash

__getpackage() {
    :
}

__depresolv() {
    :
}

__install() {
    :
}

__uninstallpackage() {
    :
}

__installpackage() {
    if [[ ${#} -ge 1 ]] ; then
        status="true"
        for i in $(seq 1 ${#}) ; do
            :
        done
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