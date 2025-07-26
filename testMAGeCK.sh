#!/bin/bash

TARGET=$1
CONTROL=$2

COUNTS_FILE=$(ls counts/*.count.txt)

TARGET_SAMPLES=$(cat key.csv | egrep ",${TARGET}$" | cut -f1 -d, | xargs | tr ' ' ',')
CONTROL_SAMPLES=$(cat key.csv | egrep ",${CONTROL}$" | cut -f1 -d, | xargs | tr ' ' ',')

echo "-t $TARGET_SAMPLES"
echo "-c $CONTROL_SAMPLES"

ODIR=out/${TARGET},${CONTROL}
mkdir -p $ODIR

. ve.mageck/bin/activate

mageck test \
     -k $COUNTS_FILE \
     -t $TARGET_SAMPLES \
     -c $CONTROL_SAMPLES \
     -n $ODIR/${TARGET}_vs_${CONTROL} \
     --control-sgrna dat/controlProbes.txt \
     --pdf-report
