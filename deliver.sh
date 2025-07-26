#!/bin/bash

DIR=$1

if [ "$#" -ne 1 ]; then
    echo -e "\n   usage: deliver.sh //pi/user/Proj_no/r_00x\n"
    exit
fi

DDIR=$DIR/sgrna/mageck
mkdir -p $DDIR
rsync -avP --exclude-from="EXC" counts $DDIR
rsync -avP --exclude-from="EXC" out $DDIR

