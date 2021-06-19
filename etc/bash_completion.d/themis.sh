#complete -W '--help --version --whocontributed' bchacktool3

_null() {
	:
}

_themis_complitation()
{
	if [ "${#COMP_WORDS[@]}" = "2" ]; then	
		COMPREPLY=($(compgen -W "help yardım makepackage paketyap localinstall lokalyukle install yükle uninstall kaldır updateindex indeksgüncelle list info bilgi version" -- "${COMP_WORDS[1]}"))
		return 0
	elif [[ "${#COMP_WORDS[@]}" -gt "2" ]] ; then
		case ${COMP_WORDS[1]} in
			[hH][eE][lL][pP]|--[hH][eE][lL][pP]|[yY][aA][rR][dD][iIıİ][mM]|--[yY][aA][rR][dD][iIıİ][mM]|-[hH])
				COMPREPLY=()
				return 0
			;;
			[iI][nN][sS][tT][aA][lL][lL]|--[iI][nN][sS][tT][aA][lL][lL]|[yY][üÜuU][kK][lL][eE]|--[yY][üÜuU][kK][lL][eE]|-[iI])
				__pkgnms() {
					if [[ $(ls /usr/share/themis/repositories | wc -l) -gt 0 ]] ; then
						for i in $(seq 1 $(ls /usr/share/themis/repositories | wc -l)) ; do
							source /usr/share/themis/repositories/$(ls /usr/share/themis/repositories | awk NR==$i'{print $1}')/index.sh
							for y in $(seq 1 $((${#packages[@]} - 1))) ; do
								echo -n "$(echo "${packages[y]}" | tr "_" " " | awk '{print $2}') "
							done
						done
					fi
				}
				COMPREPLY=($(compgen -W "$(echo $(__pkgnms))" -- "${COMP_WORDS[COMP_CWORD]}"))
			;;
			[uU][nN][iI][nN][sS][tT][aA][lL][lL]|--[uU][nN][iI][nN][sS][tT][aA][lL][lL]|[kK][aA][lL][dD][ıIiİ][rR]|--[kK][aA][lL][dD][ıIiİ][rR]|-[uU])
				#COMPREPLY=($(compgen -W "$(ls /usr/share/themis/packages)" -- "${COMP_WORDS[@]}"))
				if [[ $(ls /usr/share/themis/packages | wc -l) -gt 0 ]] ; then
					COMPREPLY=($(compgen -W "$(echo $(ls /usr/share/themis/packages))" -- "${COMP_WORDS[COMP_CWORD]}"))
				fi
				return 0			
			;;
			[uU][pP][dD][aA][tT][eE][iI][nN][dD][eE][xX]|--[uU][pP][dD][aA][tT][eE][iI][nN][dD][eE][xX]|[ıIiİ][nN][dD][eE][kK][sS][gG][üÜuU][nN][cC][eE][lL][lL][eE]|--[ıIiİ][nN][dD][eE][kK][sS][gG][üÜuU][nN][cC][eE][lL][lL][eE]|-[uU][pP])
				COMPREPLY=()
				return 0
			;;
			[lL][iI][sS][tT]|--[lL][iI][sS][tT]|-[lL])
				if [[ ${#COMP_WORDS[@]} = 3 ]] ; then
					COMPREPLY=($(compgen -W "repositories depo repo" -- "${COMP_WORDS[2]}"))
				else
					COMPREPLY=()
				fi
				return 0
			;;
			[iI][nN][fF][oO]|--[iI][nN][fF][oO]|[bB][iİıI][lL][gG][iİıI]|--[bB][iİıI][lL][gG][iİıI]|-[iI])
    			#COMPREPLY=($(compgen -o /usr/share/themis/packages -f -X '!*' -- "${COMP_WORDS[COMP_CWORD]}"))
				if [[ $(ls /usr/share/themis/packages | wc -l) -gt 0 ]] ; then
					COMPREPLY=($(compgen -W "$(echo $(ls /usr/share/themis/packages))" -- "${COMP_WORDS[COMP_CWORD]}"))
				fi
				return 0
			;;
			[vV][eE][rR][sS][iI][oO][nN]|--[vV][eE][rR][sS][iI][oO][nN]|-[vV])
				COMPREPLY=()
				return 0
			;;
			*)
				# and where you need filename completion, re-enable it and send empty COMPREPLY
				compopt -o default
				COMPREPLY=()
				return 0
			;;
		esac
	fi
	# iyi kötü buda olsun da ileride güncellenir
}

complete -F _themis_complitation themis