#!/bin/bash

#
# testMAGeCK.sh - Run MAGeCK test for differential analysis
# Version: v1.0.1
#
# This script performs differential analysis between target and control samples
# using MAGeCK test with counts data.
#
# Usage:
#   testMAGeCK.sh <target_group> <control_group>
#
# Arguments:
#   target_group    Target sample group name (from key.csv)
#   control_group   Control sample group name (from key.csv)
#
# Required files:
#   - key.csv: Maps samples to groups
#   - counts/*.count.txt: Count file from MAGeCK count
#
# Examples:
#   testMAGeCK.sh Target1 Control1
#

usage() {
    cat << EOF
testMAGeCK.sh v1.0.1

Usage: $(basename $0) <target_group> <control_group>

Run MAGeCK test for differential analysis between target and control groups.

Arguments:
  target_group     Target sample group name (from key.csv)
  control_group    Control sample group name (from key.csv)

Required files:
  - key.csv: Maps samples to groups
  - counts/*.count.txt: Count file from MAGeCK count

Examples:
  $(basename $0) Target1 Control1

EOF
    exit 1
}

# Get script directory for locating resources
SDIR=$(dirname "$(readlink -f "$0")")

# Parse command line arguments
TARGET=$1
CONTROL=$2

# Check if required arguments were provided
if [ -z "$TARGET" ] || [ -z "$CONTROL" ]; then
    usage
fi

COUNTS_FILE=$(ls counts/*.count.txt)

TARGET_SAMPLES=$(cat key.csv | egrep ",${TARGET}$" | cut -f1 -d, | xargs | tr ' ' ',')
CONTROL_SAMPLES=$(cat key.csv | egrep ",${CONTROL}$" | cut -f1 -d, | xargs | tr ' ' ',')

echo "-t $TARGET_SAMPLES"
echo "-c $CONTROL_SAMPLES"

ODIR=out/${TARGET},${CONTROL}
mkdir -p $ODIR

# Activate MAGeCK virtual environment
. $SDIR/ve.mageck/bin/activate

# Run MAGeCK test for differential analysis
mageck test \
     -k $COUNTS_FILE \
     -t $TARGET_SAMPLES \
     -c $CONTROL_SAMPLES \
     -n $ODIR/${TARGET}_vs_${CONTROL} \
     --control-sgrna $SDIR/dat/controlProbes.txt \
     --pdf-report
