#!/bin/bash
file=fruitfly.fastq
base=$(basename $file ".fastq")
for idx in ATCACC GAGGATC TCATC CGTC
    do
#    samtools-0.1.18/samtools view -Su $idx.sam | samtools sort - $idx
    java -jar picard-tools-1.84/MarkDuplicates.jar I=$idx.bam O=$idx"_nodup.bam" METRICS_FILE=$idx.txt
done
