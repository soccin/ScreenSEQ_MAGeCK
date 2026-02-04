#!/bin/bash

SDIR=$(dirname "$(readlink -f "$0")")

FDIR=$1

F1=$(find $FDIR -name '*.gz' | fgrep _R1_ | sort -V)
F2=$(find $FDIR -name '*.gz' | fgrep _R2_ | sort -V)

sampleLabels=""
for di in $(echo $F1); do
    si=$(basename $di | sed 's/_IGO.*//')
    sampleLabels=${sampleLabels},${si}
done
sampleLabels=${sampleLabels:1}

projNo=$(pwd | tr '/' '\n' | fgrep Proj_ | sed 's/Proj_//' | head -1)

. $SDIR/ve.mageck/bin/activate

mageck count \
    -l $SDIR/dat/Brunello_NoDatesLibFile.csv \
    --control-sgrna dat/controlProbes.txt \
    -n  $projNo \
    --sample-label $sampleLabels \
    --fastq $F1 \
    --fastq-2 $F2

# mageck count \
#     -l library.txt \
#     -n prefix \
#     --sample-label A,B,C,D \
#     --fastq A_1.fq.gz B_1.fq.gz C_1.fq.gz D_1.fq.gz \
#     --fastq-2 A_2.fq.gz B_2.fq.gz C_2.fq.gz D_2.fq.gz
