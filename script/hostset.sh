#!/bin/bash

num=1
cnt=0
for i in $@
do
    num=$(($num+1))
    if [ "$num" == "2" ]; then
        echo "$i hdn" | sudo tee -a  /etc/hosts
        continue
    elif [ "$(($num%2))" == "0" ]; then
        continue
    fi
    cnt=$(($cnt+1))
    echo "$i hdw$cnt" | sudo tee -a /etc/hosts
done

