#!/bin/bash
#$ -q long
#$ -j y
#$ -cwd
#$ -N fly
#$ -l mf=2G
. $HOME/.bashrc
#SGE_TASK_ID=1
a=(*sam)
base=$(basename ${a["SGE_TASK_ID"-1]} .sam)

export TMP=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TEMPDIR=/genefs/MikheyevU/temp

samtools view -Su $base.sam | novosort -t /genefs/MikheyevU/temp -r @RG"\t"ID:$base"\t"LB:Tdt"\t"SM:$base"\t"PL:ILLUMINA  -i -o $base.bam -
java -jar /apps/MikheyevU/picard-tools-1.66/MarkDuplicates.jar REMOVE_DUPLICATES=1 ASSUME_SORTED=1 METRICS_FILE=$base.txt INPUT=$base.bam OUTPUT=$base"_nodup".bam
mv $base"_nodup".bam $base.bam
samtools index $base.bam
