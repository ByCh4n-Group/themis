#!/bin/bash

pkg="aa-aa"

echo "${pkg}" | grep " "

if ! [[  -z ${pkg} ]] && [[ $(echo "${pkg}" | grep " ") = "" ]] ; then
	echo "tamam"
else
	echo "değil"
	#paket ismi boş yada boşluklu olamaz
fi

test=("aa" "bb" "cc")

echo "${test[@]}"