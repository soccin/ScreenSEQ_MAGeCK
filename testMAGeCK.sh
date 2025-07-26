#!/bin/bash

TARGET=$1
CONTROL=$2

TARGET_SAMPLES=$(cat key.csv | egrep ",${TARGET}$" | cut -f1 -d, | xargs | tr ' ' ',')
CONTROL_SAMPLES=$(cat key.csv | egrep ",${CONTROL}$" | cut -f1 -d, | xargs | tr ' ' ',')

echo "-t $TARGET_SAMPLES"
echo "-c $CONTROL_SAMPLES"

ODIR=out/${TARGET},${CONTROL}
mkdir -p $ODIR

mageck test \
     -k counts/p17150.count.txt \
     -t $TARGET_SAMPLES \
     -c $CONTROL_SAMPLES \
     -n $ODIR/${TARGET}_vs_${CONTROL} \
     --control-sgrna controlProbes.txt \
     --pdf-report
