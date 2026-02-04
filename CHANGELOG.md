# Changelog

All notable changes to the ScreenSEQ_MAGeCK pipeline will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v1.0.1] - 2026-02-04

### Added

- Comprehensive README.md documentation (290 lines)
  - TLDR section with quick-start commands
  - Table of contents for easy navigation
  - Prerequisites and installation sections
  - Complete 5-step pipeline workflow documentation
  - Metadata file format specifications with examples
  - Output file structure and column descriptions
  - Brunello library information (77,440 sgRNAs)
  - End-to-end example workflow
  - Tips and troubleshooting section

### Changed

- Made testMAGeCK.sh location-independent
  - Script can now be run from any directory
  - Uses `$SDIR` variable for virtualenv and data file paths
  - Added comprehensive documentation header
  - Added usage function with argument validation
  - Added descriptive comments throughout

### Fixed

- Typos in README.md
  - Fixed "you need to metadata files" to "you need two metadata files"
  - Fixed section header "comparison" to "comparisons"
- Formatting in VERSION.md

## [v1.0.0] - 2026-02-04

### Added

- Initial release of MAGeCK-based ScreenSEQ pipeline
- Core pipeline scripts:
  - `00.SETUP.sh` - Virtual environment and MAGeCK installation
  - `mergeFASTQBySample.sh` - FASTQ file merging by sample
  - `countMAGeCK.sh` - sgRNA counting with MAGeCK count
  - `testMAGeCK.sh` - Differential analysis with MAGeCK test
  - `diffReport.R` - Summary report generation
  - `deliver.sh` - Results archiving
- Location-independent countMAGeCK.sh with --no-R2 option
- Automatic project number extraction from paths
- Automatic IGO suffix removal from sample names
- Brunello library support (77,440 sgRNAs)
- Control probes support (1,000 non-targeting sgRNAs)
- VERSION.md with component versions

### Components

- MAGeCK: v0.5.9.5
- Python: 3.9.7
- Libraries: Brunello (77,440 sgRNAs), Control probes (1,000)

[Unreleased]: https://github.com/yourusername/ScreenSEQ_MAGeCK/compare/v1.0.1...HEAD
[v1.0.1]: https://github.com/yourusername/ScreenSEQ_MAGeCK/compare/v1.0.0...v1.0.1
[v1.0.0]: https://github.com/yourusername/ScreenSEQ_MAGeCK/releases/tag/v1.0.0
