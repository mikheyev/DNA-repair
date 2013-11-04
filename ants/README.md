# RAD-seq on museum ants

## Workflow
#### trim.sh

   - sort raw input file by barcode, trim off 3' adaptor sequence

#### map.sh

   - map files to reference, sort resulting bam, and remove unmapped reads
   
### SNP calling pipeline

Basically the same pipeline is run for the [*cflo*](https://github.com/mikheyev/DNA-repair/tree/master/museum%20ants%20test/cflo) and [*pbar*](https://github.com/mikheyev/DNA-repair/tree/master/museum%20ants%20test/pbar) data sets, with the code found in their respective folders.

#### call1.sh

   - call initial set of snps using GATK and samtools, and intersect them
   - perform base quality score recalibration (BQSR) using concordant SNP data

#### call2.sh

   - perform variant quality score recalibration using BQSR data
   - in reality, there are not enough SNPs do do this step

#### dedup.py

   - remove duplicates from a bam file with RAD-tag data with fragmented DNA. Each DNA fragment with a distinct start position and length, is assumed unique.

**Ouput of the scripts can be found in the [./output](https://github.com/mikheyev/DNA-repair/tree/master/museum%20ants%20test/output) folder at the root, and also in the *cflo* and *pbar* sub-folders for species-specific analyses.**
