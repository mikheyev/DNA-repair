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

file=data/ants_S1_L001_R1_001.fastq
base=$(basename $file ".fastq")
barcodes=(ATCACAATTC CGATCAATTC CCGTACAATTC TATCTCCAATTC TATGCTACAATTC)
idx=${barcodes["SGE_TASK_ID"-1]}
base2=`./get_bcode.py $idx`
# trim off everything after the poly-G sequence
cat $file |egrep -B1 -A2 "^"$idx | sed '/^--$/d' | fastx_trimmer -Q 33 -f ${#idx} | cutadapt -a GGGGG -m 20 -  > data/$base2.fq
