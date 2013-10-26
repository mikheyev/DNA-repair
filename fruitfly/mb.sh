#! /bin/bash
#$ -cwd
#$ -j y
#$ -q long
#$ -N bayes
#$ -pe openmpi 8

. $HOME/.bashrc

mpirun -np 8 /apps/MikheyevU/sasha/mrbayes_3.2.1/src/mb fly.nex