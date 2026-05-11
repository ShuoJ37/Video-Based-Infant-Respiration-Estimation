#!/bin/bash
#SBATCH --job-name=glsa_debug_cpu
#SBATCH --partition=msismall
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=12:00:00
#SBATCH --output=glsa_debug_cpu.out
#SBATCH --error=glsa_debug_cpu.err

module load miniforge
source activate respenv

cd /users/3/jian1105/Video-Based_Infant_Respiration_Estimation/air-400

python main.py --config "/users/3/jian1105/Video-Based_Infant_Respiration_Estimation/configs/train_size_test/efficientphys_debug_pose_glsa_small.yaml" --preprocess