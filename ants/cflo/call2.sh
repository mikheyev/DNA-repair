#!/bin/bash
#$ -q long
#$ -j y
#$ -cwd
#$ -N ant2
#$ -l h_vmem=25G
#$ -l virtual_free=25G

. $HOME/.bashrc
export TEMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

MAXMEM=20
ref=../ref/cflo_3.3.fasta 
alias GA="java -Xmx"$MAXMEM"g -Djava.io.tmpdir=/genefs/MikheyevU/temp -jar /apps/MikheyevU/sasha/GATK/GenomeAnalysisTK.jar"
alias picard="java -Xmx"$MAXMEM"g -Djava.io.tmpdir=/genefs/MikheyevU/temp -jar /apps/MikheyevU/picard-tools-1.66/"

# Calling annotations 

 GA -nct 12 \
    -T HaplotypeCaller\
    -mmq 13 \
    -R $ref \
    -A QualByDepth -A RMSMappingQuality -A HaplotypeScore -A InbreedingCoeff -A MappingQualityRankSumTest -A Coverage -A ReadPosRankSumTest -A BaseQualityRankSumTest -A ClippingRankSumTest \
    -I data/merged.recal.bam \
    --genotyping_mode DISCOVERY \
   --heterozygosity 0.005 \
    -o data/raw.vcf

samtools mpileup -ugf $ref data/merged.recal.bam | bcftools view -vcg - | vcfutils.pl varFilter -Q 20 > data/samtools.vcf

(grep ^# data/raw.vcf ;  intersectBed -wb -a data/samtools.vcf -b data/raw.vcf ) > data/samtools_gatk2.vcf 

# Variant Quality Score Recalibration (VQSR). Takes known SNP sites and uses them to filter GATK's quality scores by quality.
# This step uses R and can be memory-intensive, hence the increased memory requirement for this job.

GA \
   -T VariantRecalibrator \
   -R $ref \
   -input data/raw.vcf \
   -resource:samtools,known=false,training=true,truth=true,prior=12.0 data/samtools_gatk2.vcf \
   -an QD -an DP -an MQRankSum -an ReadPosRankSum  -an ClippingRankSum -an BaseQRankSum -an MQ \
   -mode both \
   -tranche 99.0 -tranche 90.0 -tranche 80.0 -tranche 70.0 \
   -recalFile data/output.recal \
   -tranchesFile data/output.tranches \
   -numBad 5000 \
   --maxGaussians 3 \
   -rscriptFile data/plots.R

# Apply VQSR to the data, producing a VCF marked as PASSED for sites that are OK.
# In this case we use at 90% false discovery rate, which is pretty conservative, but this parameter can be tuned

GA \
  -T ApplyRecalibration \
   -R $ref \
   -input data/raw.vcf \
   --ts_filter_level 90.0 \
   -tranchesFile data/output.tranches \
   -recalFile data/output.recal \
   -mode BOTH \
   -o data/recalibrated.filtered.vcf
 

