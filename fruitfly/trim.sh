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

barcodes=(ATCACC GAGGATC TCATC CGTC AGATTC GTCCAAC)
idx=${barcodes["SGE_TASK_ID"-1]}
base=`./get_bcode.py $idx`
(zcat data/hiseq/hiseq.fastq.gz ; cat data/miseq/fruitfly.fastq) | egrep -B1 -A2 "^"$idx | sed '/^--$/d' | fastx_trimmer -Q 33 -f ${#idx} | cutadapt -a GGGGG - | cutadapt -g CCCCCCC -O 1 -m 20 - > data/$base.fq

