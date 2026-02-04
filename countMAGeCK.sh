#!/bin/bash

#
# countMAGeCK.sh - Run MAGeCK count on paired FASTQ files
# Version: v1.0.0
#
# This script finds R1 (and optionally R2) FASTQ files in a directory,
# extracts sample labels, and runs MAGeCK count with the Brunello library.
#
# Usage:
#   countMAGeCK.sh [--no-R2] <fastq_directory>
#
# Arguments:
#   fastq_directory  Directory containing gzipped FASTQ files
#                    Files should follow naming: *_R1_*.gz and *_R2_*.gz
#
# Options:
#   --no-R2         Run single-end mode (R1 only), skip R2 reads
#
# Examples:
#   countMAGeCK.sh /path/to/fastq/dir          # paired-end mode
#   countMAGeCK.sh --no-R2 /path/to/fastq/dir  # single-end mode
#

usage() {
    cat << EOF
countMAGeCK.sh v1.0.0

Usage: $(basename $0) [--no-R2] <fastq_directory>

Run MAGeCK count on FASTQ files with the Brunello library.

Arguments:
  fastq_directory    Directory containing gzipped FASTQ files
                     Files should follow naming: *_R1_*.gz and *_R2_*.gz

Options:
  --no-R2           Run single-end mode (R1 only), skip R2 reads

Examples:
  $(basename $0) /path/to/fastq/dir          # paired-end mode
  $(basename $0) --no-R2 /path/to/fastq/dir  # single-end mode

EOF
    exit 1
}

# Get script directory for locating resources (library, virtualenv)
SDIR=$(dirname "$(readlink -f "$0")")

# Default to paired-end mode (use R2)
USE_R2=true

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --no-R2)
            USE_R2=false
            shift
            ;;
        *)
            FDIR=$1
            shift
            ;;
    esac
done

# Check if FASTQ directory was provided
if [ -z "$FDIR" ]; then
    usage
fi

# Find all R1 and R2 FASTQ files (gzipped)
# Sort naturally by version number (_R1_ vs _R2_)
F1=$(find $FDIR -name '*.gz' | fgrep _R1_ | sort -V)
F2=$(find $FDIR -name '*.gz' | fgrep _R2_ | sort -V)

# Build FASTQ argument string based on sequencing mode
if [ "$USE_R2" = true ]; then
    FASTQ="--fastq $F1 --fastq-2 $F2"  # Paired-end
else
    FASTQ="--fastq $F1"                 # Single-end
fi

# Extract sample labels from R1 filenames
# Remove IGO suffix and everything after it
sampleLabels=""
for di in $(echo $F1); do
    si=$(basename $di | sed 's/_IGO.*//')
    sampleLabels=${sampleLabels},${si}
done
sampleLabels=${sampleLabels:1}  # Remove leading comma

# Extract project number from current working directory path
# Looks for directories named Proj_* in the path
projNo=$(pwd | tr '/' '\n' | fgrep Proj_ | sed 's/Proj_//' | head -1)

# Activate MAGeCK virtual environment
. $SDIR/ve.mageck/bin/activate

# Run MAGeCK count with Brunello library
mageck count \
    -l $SDIR/dat/Brunello_NoDatesLibFile.csv \
    --control-sgrna dat/controlProbes.txt \
    -n  $projNo \
    --sample-label $sampleLabels \
    $FASTQ
