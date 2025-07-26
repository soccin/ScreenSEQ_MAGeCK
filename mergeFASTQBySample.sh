#!/bin/bash

MAP=$1

PROJNO=$(cat $MAP | cut -f4 | sed 's/.*Project_//' | cut -f1 -d/ | uniq)

for sample in $(cat $MAP | cut -f4 | sed 's/.*Sample_//'); do
    echo $sample
    ODIR=FASTQ/Project_${PROJNO}/Sample_${sample}
    mkdir -p $ODIR
    cat \
        $(cat $MAP | cut -f4 | fgrep $sample | xargs -I % find % -name "*_R1_*" | sort -V) \
        > $ODIR/${sample}_L001_R1_001.fastq.gz &
    cat \
        $(cat $MAP | cut -f4 | fgrep $sample | xargs -I % find % -name "*_R2_*" | sort -V) \
        > $ODIR/${sample}_L001_R2_001.fastq.gz &
done

echo "waiting..."
wait
echo "done"


