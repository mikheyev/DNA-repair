#!/bin/bash
#$ -q genomics
#$ -j y
#$ -cwd
#$ -N ant
#$ -l h_vmem=10G
#$ -l virtual_free=10G

. $HOME/.bashrc
export TEMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

MAXMEM=8
ref=../ref/pbar_1.0.fasta
alias GA="java -Xmx"$MAXMEM"g -Djava.io.tmpdir=/genefs/MikheyevU/temp -jar /apps/MikheyevU/sasha/GATK/GenomeAnalysisTK.jar"
alias picard="java -Xmx"$MAXMEM"g -Djava.io.tmpdir=/genefs/MikheyevU/temp -jar /apps/MikheyevU/picard-tools-1.66/"

inputs=`for i in ../data/Pbar?_nodup.bam ; do echo -ne "-I "$i" "; done`

# # Running first-pass base calls

GA -nct 12\
  -mmq 13 \
   -T HaplotypeCaller\
   -R $ref \
   $inputs \
   --genotyping_mode DISCOVERY \
   --heterozygosity 0.005 \
   -o data/raw1.vcf

#    -A QualByDepth -A RMSMappingQuality -A FisherStrand -A HaplotypeScore -A InbreedingCoeff -A MappingQualityRankSumTest -A Coverage -A ReadPosRankSumTest -A BaseQualityRankSumTest -A ClippingRankSumTest \

# Running another independet SNP caller

samtools mpileup -ugf $ref ../data/Pbar?.bam | bcftools view -vcg - | vcfutils.pl varFilter -Q 20 > data/samtools.vcf


# #Finding sites in common between the two approaches

(grep ^# data/raw1.vcf ;  intersectBed -wa -a data/samtools.vcf -b data/raw1.vcf ) > data/samtools_gatk1.vcf


# Applying base quality recalibration using the set of sites found by both callers

GA \
   -nct 12 \
   -T BaseRecalibrator \
   $inputs  \
   -R $ref \
   -knownSites data/samtools_gatk1.vcf \
   -o data/recal_data.table

# Prining recalibrated BAM file

 GA \
    -nct 12 \
    -T PrintReads \
    $inputs \
    -R $ref  \
    -BQSR data/recal_data.table \
    -o data/merged.recal.bam

# Preparing comparison between recalibrated and non-recalibrated data

GA \
   -nct 12 \
   -T BaseRecalibrator \
   -I data/merged.recal.bam  \
   -R $ref \
   -knownSites data/samtools_gatk1.vcf \
   -BQSR data/recal_data.table \
   -o data/post_recal_data.table

# Preparing PDF files with comparison between recalibrated and non-recalibrated data

GA \
    -T AnalyzeCovariates \
    -R $ref \
    -before data/recal_data.table \
    -after data/post_recal_data.table \
    -plots data/recalibration_plots.pdf

qsub call2.sh