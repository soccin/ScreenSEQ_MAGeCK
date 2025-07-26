# ScreenSEQ_MAGeCK

MAGeCK version of ScreenSEQ pipeline

## Usage:

- Remember to merge the FASTQ files with `mergeFASTQBySample.sh`

- Count all samples at once, `countMAGeCK.sh` takes the FASTQ dir as input

## Testing metadata files

For the differential analysis (testing) you need to metadata files

### key.csv

This maps samples to groups:

```
# key.csv
sampleA-rep1,sampleA
sampleA-rep2,sampleA
sampleB-rep1,sampleB
```

*N.B.* no header

### comparison

This file is tab delimited Target vs Control
```
# comparisons
Target1 Control1
Target2 Control2
```
