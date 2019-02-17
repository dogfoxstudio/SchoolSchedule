#!/bin/bash

profiles=$(sqlite3 $1 '
    select profile from (select priority, profile from main where strftime("%w", "now") = strftime("%w", day))
')

dt=$(sqlite3 $1 'select date("now")')
echo $dt
./cronupd.sh cmd1 "09-00" "2019-2-30"
#echo $profiles

if [ $profiles ]; then
    profiles=$(echo $profiles | sed 's/ /,/g')

    echo $profiles

    bells1=$(sqlite3 $1 'select time from bells where profile_id in($profiles) and type_id=1')
    bells2=$(sqlite3 $1 'select time from bells where profile_id in($profiles) and type_id=2')
    bells3=$(sqlite3 $1 'select time from bells where profile_id in($profiles) and type_id=3')
    
    if [ $bells1 ]; then
        for tm in $bells1
        do
            ./cronupd.sh cmd1 $tm $dt
        done
    fi
    
    if [ $bells2 ]; then
        for tm in $bells2
        do
            ./cronupd.sh cmd2 $tm $dt
        done
    fi
    
    if [ $bells3 ]; then
        for tm in $bells3
        do
            ./cronupd.sh cmd3 $tm $dt
        done
    fi
fi



