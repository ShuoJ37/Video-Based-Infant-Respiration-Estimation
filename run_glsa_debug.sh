#!/bin/bash
#SBATCH --job-name=pose_glsa_debug
#SBATCH --partition=msigpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --gres=gpu:1
#SBATCH --time=12:00:00
#SBATCH --output=pose_glsa_debug.out
#SBATCH --error=pose_glsa_debug.err

echo "=========================================="
echo "Starting Pose GLSA Debug Run"
echo "Job ID: $SLURM_JOB_ID"
echo "Node: $(hostname)"
echo "Start time: $(date)"
echo "=========================================="

#
# Load environment
#
module load miniforge
source activate respenv

nvidia-smi

#
# Go to project directory
#
cd /users/3/jian1105/Video-Based_Infant_Respiration_Estimation/air-400

#
# Remove old cache for clean preprocessing
#
rm -rf /users/3/jian1105/Video-Based_Infant_Respiration_Estimation/air-400/cache_pose_glsa_debug

#
# Run training
#
python main.py \
  --config configs/train/efficientphys_pose_glsa_debug.yaml

echo "=========================================="
echo "Finished at: $(date)"
echo "=========================================="