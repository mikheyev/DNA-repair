# RAD-seq on Hawaiian Drosophila

## Workflow
#### trim.sh

   - sort raw input file by barcode, trim off 3' adaptor sequence and poly C repat at 5' end.

#### map.sh

   - map files to reference, sort resulting bam, remove unmapped reads, and mark duplicates
   
   
#### call1.sh

   - call initial set of snps using GATK and samtools, and intersect them
   - perform base quality score recalibration (BQSR) using concordant SNP data

#### call2.sh

   - perform variant quality score recalibration using BQSR data

#### vcf2nex.py

   - convert VCF output from SNP caller into a MrBayes nexus file

#### mb.sh

   - execute **fly.nex**, produced by vcf2nex.py and compute phylogeny



**Ouput of the scripts can be found in the [./output](https://github.com/mikheyev/DNA-repair/tree/master/fruitfly/output) folder.**
