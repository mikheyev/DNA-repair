#!/bin/bash
#$ -q short
#$ -j y
#$ -cwd
#$ -l h_vmem=10G
#$ -l virtual_free=10G
#$ -N map
. $HOME/.bashrc
export TEMPDIR=/genefs/MikheyevU/temp
export TMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

files=(./data/*.fq)
file=`basename ${files["SGE_TASK_ID"-1]}`
base=`basename $file .fq`
if [[ $file == Cflo* ]]
	then 
	ref=cflo
elif [[ $file == Pbar* ]]
	then 
	ref=pbar
else
	ref=lhum
fi

bowtie2 -p 8 -N 1 -L 20 -i S,1,0.50 -D 20 -R 3  -x ref/$ref -U data/$file --sam-rg ID:$base --sam-rg LB:TdT --sam-rg SM:$base --sam-rg PL:ILLUMINA | samtools view -Su - | novosort -c 2 --ram 5G -t $TEMP -i -o data/$base.bam -
