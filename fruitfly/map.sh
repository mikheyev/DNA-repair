#!/bin/bash
file=fruitfly.fastq
base=$(basename $file ".fastq")
for idx in ATCACC  GAGGATC TCATC CGTC AGATTC GTCCAAC
    do
    bowtie2 -p 8 -x dgri/dgri -U $idx.fq -S $idx.sam
done
