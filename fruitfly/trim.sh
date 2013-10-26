#!/bin/bash
#$ -q short
#$ -j y
#$ -cwd
#$ -l h_vmem=4G
#$ -l virtual_free=4G
#$ -N trim
. $HOME/.bashrc
export TEMPDIR=/genefs/MikheyevU/temp
export TMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

file=fruitfly.fastq
base=$(basename $file ".fastq")
barcodes=(ATCACC GAGGATC TCATC CGTC AGATTC GTCCAAC)
idx=${barcodes["SGE_TASK_ID"-1]}
base2=$(awk -v code=$(basename $idx C) 'BEGIN {fly["ATCAC"]="hawaiiensis" ; fly["GAGGAT"]="paucipuncta"; fly["TCAT"]="picticornis";fly["CGT"]="anomalipes";fly["AGATT"]="grimshawi";fly["GTCCAA"]="silvestris" } END {print fly[code]}')
cat $file |egrep -B1 -A2 "^"$idx | sed '/^--$/d' | fastx_trimmer -Q 33 -f ${#idx} | cutadapt -a GGGGG -m 20 - | cutadapt -g CCCCCCC -O 1 -m 20 -  > $base2.fq
