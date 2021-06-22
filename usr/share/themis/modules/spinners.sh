#!/bin/bash

# source: https://stackoverflow.com/questions/9954794/execute-a-shell-function-with-timeout#:~:text=timeout%20is%20a%20command%20%2D%20so,child%20process%20of%20your%20shell.

timeout="0"

 ##!-> source spinners.sh

 ##!->
 ##!-> timeout="3" # any time as second
 ##!-> spinone 

spinnerofthefirssPinner() {
spin='-\|/'

i=0
while :; do
  i=$(( (i+1) %4 ))
  printf "\r${spin:$i:1}"
  sleep .1
done
}

spinone() {
    if [[ ${timeout} != 0 ]] ; then
        timeout "${timeout}" cat <( spinnerofthefirssPinner ) ; echo ""
    else
        spinnerofthefirssPinner
    fi
}

    ##!->
    ##!-> sleep="0.5" # any time as second
    ##!-> spintwo

spintwo() {
    count=0
    total=34
    pstr="[=======================================================================]"
    
    [ -z $sleep ] && sleep="0.5" || sleep="$sleep"

    while [ $count -lt $total ]; do
    count=$(( $count + 2 ))
    pd=$(( $count * 73 / $total ))
    printf "\r%3d.%1d%% %.${pd}s" $(( $count * 100 / $total )) $(( ($count * 1000 / $total) % 100 )) $pstr
    sleep ${sleep} # this is work
    done
}

progressBarWidth=20

# Function to draw progress bar
progressBar () {

  # Calculate number of fill/empty slots in the bar
  progress=$(echo "$progressBarWidth/$taskCount*$tasksDone" | bc -l)  
  fill=$(printf "%.0f\n" $progress)
  if [ $fill -gt $progressBarWidth ]; then
    fill=$progressBarWidth
  fi
  empty=$(($fill-$progressBarWidth))

  # Percentage Calculation
  percent=$(echo "100/$taskCount*$tasksDone" | bc -l)
  percent=$(printf "%0.2f\n" $percent)
  if [ $(echo "$percent>100" | bc) -gt 0 ]; then
    percent="100.00"
  fi

  # Output to screen
  printf "\r["
  printf "%${fill}s" '' | tr ' ' x
  printf "%${empty}s" '' | tr ' ' 0
  printf "] $percent%%"
}

    ##!->
    ##!-> sleep="0.5" 
    ##!-> spinthree

spinthree() {
    ## Collect task count
    taskCount=33
    tasksDone=0

    [ -z $1 ] && sleep="0.1" || sleep="$1"

    while [ $tasksDone -le $taskCount ]; do

    # Do your task
    (( tasksDone += 1 ))
    # Draw the progress bar
    progressBar $taskCount $taskDone
    sleep $sleep
    done
    echo
}

    ##!->
    ##!->  a script by extensionsapp
    ##!-> progreSh 10 ; some command
    ##!-> progreSh 20 ; some command
    ##!-> progreSh 30 ; some command
    ##!-> progreSh 40 ; some command
    ##!-> progreSh 50 ; some command
    ##!-> progreSh 60 ; some command
    ##!-> progreSh 70 ; some command
    ##!-> progreSh 80 ; some command
    ##!-> progreSh 90 ; some command
    ##!-> progreSh 100 ; some command

#####################################################################################################
# a scirpt by https://github.com/extensionsapp & source: https://github.com/extensionsapp/progre.sh #
#####################################################################################################

progreSh() {
    LR='\033[1;31m'
    LG='\033[1;32m'
    LY='\033[1;33m'
    LC='\033[1;36m'
    LW='\033[1;37m'
    NC='\033[0m'
    if [ "${1}" = "0" ]; then TME=$(date +"%s"); fi
    PRC=`printf "%.0f" ${1}`
    SHW=`printf "%3d\n" ${PRC}`
    LNE=`printf "%.0f" $((${PRC}/2))`
    LRR=`printf "%.0f" $((${PRC}/2-12))`; if [ ${LRR} -le 0 ]; then LRR=0; fi;
    LYY=`printf "%.0f" $((${PRC}/2-24))`; if [ ${LYY} -le 0 ]; then LYY=0; fi;
    LCC=`printf "%.0f" $((${PRC}/2-36))`; if [ ${LCC} -le 0 ]; then LCC=0; fi;
    LGG=`printf "%.0f" $((${PRC}/2-48))`; if [ ${LGG} -le 0 ]; then LGG=0; fi;
    LRR_=""
    LYY_=""
    LCC_=""
    LGG_=""
    for ((i=1;i<=13;i++))
    do
    	DOTS=""; for ((ii=${i};ii<13;ii++)); do DOTS="${DOTS}."; done
    	if [ ${i} -le ${LNE} ]; then LRR_="${LRR_}#"; else LRR_="${LRR_}."; fi
    	echo -ne "  ${LW}${SEC}  ${LR}${LRR_}${DOTS}${LY}............${LC}............${LG}............ ${SHW}%${NC}\r"
    	if [ ${LNE} -ge 1 ]; then sleep .05; fi
    done
    for ((i=14;i<=25;i++))
    do
    	DOTS=""; for ((ii=${i};ii<25;ii++)); do DOTS="${DOTS}."; done
    	if [ ${i} -le ${LNE} ]; then LYY_="${LYY_}#"; else LYY_="${LYY_}."; fi
    	echo -ne "  ${LW}${SEC}  ${LR}${LRR_}${LY}${LYY_}${DOTS}${LC}............${LG}............ ${SHW}%${NC}\r"
    	if [ ${LNE} -ge 14 ]; then sleep .05; fi
    done
    for ((i=26;i<=37;i++))
    do
    	DOTS=""; for ((ii=${i};ii<37;ii++)); do DOTS="${DOTS}."; done
    	if [ ${i} -le ${LNE} ]; then LCC_="${LCC_}#"; else LCC_="${LCC_}."; fi
    	echo -ne "  ${LW}${SEC}  ${LR}${LRR_}${LY}${LYY_}${LC}${LCC_}${DOTS}${LG}............ ${SHW}%${NC}\r"
    	if [ ${LNE} -ge 26 ]; then sleep .05; fi
    done
    for ((i=38;i<=49;i++))
    do
    	DOTS=""; for ((ii=${i};ii<49;ii++)); do DOTS="${DOTS}."; done
    	if [ ${i} -le ${LNE} ]; then LGG_="${LGG_}#"; else LGG_="${LGG_}."; fi
    	echo -ne "  ${LW}${SEC}  ${LR}${LRR_}${LY}${LYY_}${LC}${LCC_}${LG}${LGG_}${DOTS} ${SHW}%${NC}\r"
    	if [ ${LNE} -ge 38 ]; then sleep .05; fi
    done
}


##!-> Author: Tasos Latsas

##!-> spinner.sh
##!->
##!-> Display an awesome 'spinner' while running your long shell commands
##!->
##!-> Do *NOT* call _spinner function directly.
##!-> Use {start,stop}_spinner wrapper functions

##!-> usage:
##!->   1. source this script in your's
##!->   2. start the spinner:
##!->       start_spinner [display-message-here]
##!->   3. run your command
##!->   4. stop the spinner:
##!->       stop_spinner [your command's exit status]
#
# Also see: test.sh


function _spinner() {
    ##!-> $1 start/stop
    ##!->
    ##!-> on start: $2 display message
    ##!-> on stop : $2 process exit status
    ##!->           $3 spinner function pid (supplied from stop_spinner)

    local on_success="DONE"
    local on_fail="FAIL"
    local white="\e[1;37m"
    local green="\e[1;32m"
    local red="\e[1;31m"
    local nc="\e[0m"

    case $1 in
        start)
            ##!-> calculate the column where spinner and status msg will be displayed
            let column=$(tput cols)-${#2}-8
            ##!-> display message and position the cursor in $column column
            echo -ne ${2}
            printf "%${column}s"

            ##!-> start spinner
            i=1
            sp='\|/-'
            delay=${SPINNER_DELAY:-0.15}

            while :
            do
                printf "\b${sp:i++%${#sp}:1}"
                sleep $delay
            done
            ;;
        stop)
            if [[ -z ${3} ]]; then
                echo "spinner is not running.."
                exit 1
            fi

            kill $3 > /dev/null 2>&1

            ##!-> inform the user uppon success or failure
            echo -en "\b["
            if [[ $2 -eq 0 ]]; then
                echo -en "${green}${on_success}${nc}"
            else
                echo -en "${red}${on_fail}${nc}"
            fi
            echo -e "]"
            ;;
        *)
            echo "invalid argument, try {start/stop}"
            exit 1
            ;;
    esac
}

    #!-> usage:
    #!-> start_spinner "any text"
    #!-> stop_spinner "any text"

function start_spinner {
    # $1 : msg to display
    _spinner "start" "${1}" &
    # set global spinner pid
    _sp_pid=$!
    disown
}

function stop_spinner {
    # $1 : command exit status
    _spinner "stop" $1 $_sp_pid
    unset _sp_pid
}