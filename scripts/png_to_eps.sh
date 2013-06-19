#!/bin/bash

CONVERT="/usr/local/bin/convert"

find . -iname "*.png" | while read -d $'\n' png 
do 
    eps="${png%.png}.eps"
    ! [ -f "${eps}" ] && ${CONVERT} ${png} ${eps}
done
