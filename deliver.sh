#!/bin/bash

DDIR=$1

if [ "$#" -ne 1 ]; then
    echo -e "\n   usage: deliver.sh //pi/user/Proj_no/r_00x\n"
    exit
fi

mkdir -p $DDIR/mageck
rsync -avP --exclude-from="EXC" counts $DDIR/mageck
rsync -avP --exclude-from="EXC" out $DDIR/mageck

