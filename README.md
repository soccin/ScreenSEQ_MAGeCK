# ScreenSEQ_MAGeCK

MAGeCK version of ScreenSEQ pipeline for CRISPR screen analysis

**Version:** v1.0.0

## TLDR

```bash
./00.SETUP.sh                              # One-time setup
./mergeFASTQBySample.sh mapping_file.txt   # Merge FASTQs
./countMAGeCK.sh FASTQ/Project_*/          # Count sgRNAs
# Create key.csv and comparisons files
./testMAGeCK.sh Treatment Control          # Differential analysis
```

See [Complete Example](#complete-example) for detailed workflow.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Pipeline Workflow](#pipeline-workflow)
  - [Step 1: Merge FASTQ Files](#step-1-merge-fastq-files)
  - [Step 2: Count sgRNAs](#step-2-count-sgrnas)
  - [Step 3: Differential Analysis](#step-3-differential-analysis)
  - [Step 4: Generate Summary Report](#step-4-generate-summary-report-optional)
  - [Step 5: Archive Results](#step-5-archive-results-optional)
- [Metadata Files](#metadata-files)
- [Output Files](#output-files)
- [Library Information](#library-information)
- [Complete Example](#complete-example)
- [Tips and Troubleshooting](#tips-and-troubleshooting)

## Prerequisites

- Python 3.9.7+
- Required Python modules: numpy, scipy, pandas
- LSF/cluster environment (for parallel processing)
- Sufficient disk space for FASTQ files and count data

## Installation

Run the setup script to create a virtual environment and install MAGeCK v0.5.9.5:

```bash
./00.SETUP.sh
```

This will:
- Download MAGeCK v0.5.9.5 source code
- Create a virtual environment in `ve.mageck/`
- Install required Python packages (numpy, scipy)
- Install MAGeCK

## Pipeline Workflow

### Step 1: Merge FASTQ Files

Merge FASTQ files by sample using a mapping file:

```bash
./mergeFASTQBySample.sh mapping_file.txt
```

**Input format:** Tab-delimited mapping file with FASTQ directory paths in column 4.
The script extracts sample names from paths (after `Sample_`) and project number (after `Project_`).

**Output:** Merged FASTQ files in `FASTQ/Project_<PROJNO>/Sample_<sample>/` directory structure.
Files are named: `<sample>_L001_R1_001.fastq.gz` and `<sample>_L001_R2_001.fastq.gz`

### Step 2: Count sgRNAs

Count sgRNA reads from FASTQ files:

```bash
# Paired-end mode (default)
./countMAGeCK.sh FASTQ/Project_12345/

# Single-end mode (R1 only)
./countMAGeCK.sh --no-R2 FASTQ/Project_12345/
```

**Input:** Directory containing FASTQ files with naming pattern `*_R1_*.gz` and `*_R2_*.gz`

**Output:** Count file in `counts/<ProjectNo>.count.txt`

The script automatically:
- Extracts project number from the path (e.g., `Proj_12345` becomes `12345`)
- Removes IGO suffixes from sample names
- Uses the Brunello library from `dat/Brunello_NoDatesLibFile.csv`
- Uses control probes from `dat/controlProbes.txt`

### Step 3: Differential Analysis

Before running differential analysis, create two metadata files: `key.csv` and `comparisons`.

Run MAGeCK test for differential analysis:

```bash
./testMAGeCK.sh <target_group> <control_group>
```

**Example:**
```bash
./testMAGeCK.sh Treatment Control
```

**Output:** Results in `out/<Target>,<Control>/` directory containing:
- `<Target>_vs_<Control>.gene_summary.txt` - Gene-level results
- `<Target>_vs_<Control>.sgrna_summary.txt` - sgRNA-level results
- `<Target>_vs_<Control>.pdf` - QC plots and visualizations

**Running multiple comparisons:**
```bash
# Loop through comparisons file
while read target control; do
    ./testMAGeCK.sh $target $control
done < comparisons
```

### Step 4: Generate Summary Report (Optional)

Compile all differential results into an Excel file:

```bash
Rscript diffReport.R
```

This script:
- Reads all gene summary files from `out/` directory
- Filters genes with FDR < 0.05
- Creates separate sheets for positive and negative enrichment
- Outputs: `Proj_<PROJNO>_DiffGenes_MAGeCK.xlsx`

### Step 5: Archive Results (Optional)

Archive counts and results to a delivery location:

```bash
./deliver.sh /path/to/pi/Proj_XXXXX/r_XXX
```

This copies `counts/` and `out/` directories to `<delivery_path>/sgrna/mageck/`

## Metadata Files

### key.csv

Maps sample names to group labels. Used by `testMAGeCK.sh` to identify replicates.

**Format:** Comma-separated, no header

```
Sample1_rep1,Control
Sample1_rep2,Control
Sample2_rep1,Treatment
Sample2_rep2,Treatment
```

**Notes:**
- IGO suffixes are automatically removed from sample names
- Sample names should match those in the count file

### comparisons

Defines which groups to compare in differential analysis.

**Format:** Tab-delimited, one comparison per line

```
Treatment1	Control
Treatment2	Control
Treatment1	Treatment2
```

**Notes:**
- First column: target group
- Second column: control group
- Can have multiple comparisons with different groups

## Output Files

### Directory Structure

```
counts/
  └── <ProjectNo>.count.txt          # sgRNA counts per sample

out/
  └── <Target>,<Control>/
      ├── <Target>_vs_<Control>.gene_summary.txt    # Gene-level results
      ├── <Target>_vs_<Control>.sgrna_summary.txt   # sgRNA-level results
      └── <Target>_vs_<Control>.pdf                 # QC plots
```

### Summary File Columns

**gene_summary.txt** key columns:
- `id` - Gene name
- `pos|score`, `neg|score` - Enrichment scores
- `pos|fdr`, `neg|fdr` - False discovery rates
- `pos|lfc`, `neg|lfc` - Log2 fold changes

**sgrna_summary.txt** key columns:
- `sgrna` - sgRNA sequence identifier
- `Gene` - Target gene
- `LFC` - Log2 fold change
- `FDR` - False discovery rate
- `high_in_treatment` - Boolean indicating enrichment direction

## Library Information

**Brunello library:**
- Location: `dat/Brunello_NoDatesLibFile.csv`
- Contains: 77,440 sgRNAs targeting human genes
- Design: ~4 sgRNAs per gene for robust detection
- Format: `GeneID;sgRNA_num,Sequence,Gene`

**Control probes:**
- Location: `dat/controlProbes.txt`
- Contains: 1,000 non-targeting control sgRNAs
- Used for normalization and background estimation

## Complete Example

End-to-end workflow for a typical CRISPR screen analysis:

```bash
# 1. One-time setup
./00.SETUP.sh

# 2. Merge FASTQ files by sample
./mergeFASTQBySample.sh mapping_file.txt

# 3. Count sgRNAs (paired-end)
./countMAGeCK.sh FASTQ/Project_12345/

# 4. Create key.csv to map samples to groups
cat > key.csv <<EOF
Sample1_rep1,Control
Sample1_rep2,Control
Sample2_rep1,Treatment
Sample2_rep2,Treatment
EOF

# 5. Create comparisons file
cat > comparisons <<EOF
Treatment	Control
EOF

# 6. Run differential analysis
./testMAGeCK.sh Treatment Control

# 7. (Optional) Generate summary report
Rscript diffReport.R

# 8. (Optional) Archive results
./deliver.sh /path/to/delivery/Proj_12345/r_001
```

## Tips and Troubleshooting

**General:**
- Scripts are location-independent and can be run from any directory
- Project number is automatically extracted from path (e.g., `Proj_12345`)
- IGO suffixes are automatically removed from sample names

**Single-end data:**
- Use `--no-R2` flag with `countMAGeCK.sh` for single-end sequencing data
- This skips R2 reads and only uses R1

**Checking results:**
- Always verify the count file (`counts/<ProjectNo>.count.txt`) before running tests
- Check that sample names in `key.csv` match those in the count file
- Look for QC plots in PDF output to assess screen quality

**Multiple comparisons:**
- You can run multiple pairwise comparisons by looping through the `comparisons` file
- Each comparison creates a separate output directory

**Memory and performance:**
- Counting step may take several hours for large screens
- Differential analysis is relatively fast (minutes per comparison)

## Version Information

- Pipeline version: v1.0.0
- MAGeCK version: v0.5.9.5
- Python version: 3.9.7

See [VERSION.md](VERSION.md) for detailed version history.
