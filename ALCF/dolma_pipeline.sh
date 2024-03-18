#!/bin/bash
#PBS -A datascience
#PBS -l walltime=3:00:00
#PBS -l nodes=64:ppn=4
#PBS -l filesystems=eagle:home
cd ${PBS_O_WORKDIR}
task=$1
PBS_JOBSIZE=$(cat $PBS_NODEFILE | uniq | wc -l)
module load conda/2023-10-04
conda activate base 
export NUM_WORKERS=${NUM_WORKERS:-16}
aprun -n $((PBS_JOBSIZE*4)) -N 4 --cc depth -d $NUM_WORKERS -e OMP_NUM_THREADS=$NUM_WORKERS ./local_rank.sh ./run_dolma.sh $task
