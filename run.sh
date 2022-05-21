#!/bin/bash
#SBATCH --account=ec34
#SBATCH --job-name=singularity-vc-workflow
#SBATCH -c 4 # Cores assigned to each task
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mem-per-cpu=4G
#SBATCH --time=00:30:00

echo "Start"
singularity exec vc_norbis_latest.sif bash vc_workflow.sh
echo "End"
