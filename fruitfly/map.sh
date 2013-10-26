#!/bin/bash
#$ -q short
#$ -j y
#$ -cwd
#$ -l h_vmem=20G
#$ -l virtual_free=20G
#$ -N map
. $HOME/.bashrc
export TEMPDIR=/genefs/MikheyevU/temp
export TMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

files=(data/*.fq)
file=`basename ${files["SGE_TASK_ID"-1]}`
base=$(basename $file .fq)

# bowtie2 -p 8 --very-sensitive-local -x ./dgri/dgri --sam-rg ID:$base --sam-rg LB:TdT --sam-rg SM:$base --sam-rg PL:ILLUMINA -U data/$file | samtools view -Su -F4 - | novosort -t $TEMP -c 2 --ram 5G -i -o data/$base.bam -

java -jar /apps/MikheyevU/picard-tools-1.66/MarkDuplicates.jar REMOVE_DUPLICATES=1 ASSUME_SORTED=1 METRICS_FILE=data/$base.txt INPUT=data/$base.bam OUTPUT=data/$base"_nodup.bam"

mv data/$base"_nodup.bam" data/$base.bam

samtools index data/$base.bam

