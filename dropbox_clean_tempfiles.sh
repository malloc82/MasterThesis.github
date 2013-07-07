#!/bin/bash

find .     -iname *.aux \
       -or -iname *.toc \
       -or -iname *.log \
       -or -iname *.dvi | while read -d $'\n' temp_file
do
    echo "remove ${temp_file}"
    rm "${temp_file}"
done

