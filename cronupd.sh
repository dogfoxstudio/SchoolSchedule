#!/bin/bash

# $1 cmd
# $2 time hour/minute
# $3 dat year/month/day
# $4 delimiter

delimiter="-"
dat="0"

if [ "$1" -a "$2" ]; then
    cmd=$1
    time=$2
    if [ $4 ]; then
            delimiter=$4
    fi
    
    if [[ $3 != "0" ]]; then
        dat=$3
        dat=${dat#*-}
    fi 
else
    echo "cronupd.sh [COMMAND] [TIME] [DATE=0] [DELIMITER='-']"
    exit
fi

rm /tmp/cron-* -f
conf=$(mktemp -p /tmp cron-XXXX)


if [[ $dat != "0" ]]; then
    #    minute              hour                day                month              weekday     command
    echo ${time#*$delimiter} ${time%$delimiter*} ${dat#*$delimiter} ${dat%$delimiter*} "*"         $cmd    > $conf
else
    echo ${time#*$delimiter} ${time%$delimiter*} "*" "*" "*"      $cmd    > $conf
fi

echo $conf
crontab $conf
