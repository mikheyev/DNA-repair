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
base2=$(awk -v code=$(basename $base C) 'BEGIN {fly["ATCAC"]="hawaiiensis" ; fly["GAGGAT"]="paucipuncta"; fly["TCAT"]="picticornis";fly["CGT"]="anomalipes";fly["AGATT"]="grimshawi";fly["GTCCAA"]="silvestris" } END {print fly[code]}')

export TMP=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TEMPDIR=/genefs/MikheyevU/temp

samtools view -Su $base.sam | novosort -t /genefs/MikheyevU/temp -r @RG"\t"ID:$base2"\t"LB:Tdt"\t"SM:$base2"\t"PL:ILLUMINA  -i -o $base2.bam -
java -jar /apps/MikheyevU/picard-tools-1.66/MarkDuplicates.jar REMOVE_DUPLICATES=1 ASSUME_SORTED=1 METRICS_FILE=$base2.txt INPUT=$base2.bam OUTPUT=$base2"_nodup".bam
mv $base2"_nodup".bam $base2.bam
samtools index $base2.bam
