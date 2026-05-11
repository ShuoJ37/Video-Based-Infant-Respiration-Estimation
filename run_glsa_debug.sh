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

PROJECT_DIR="/users/3/jian1105/Video-Based_Infant_Respiration_Estimation/air-400"

CONFIG_FILE="/users/3/jian1105/Video-Based_Infant_Respiration_Estimation/configs/train/efficientphys_pose_glsa_debug.yaml"

CACHE_DIR="/users/3/jian1105/Video-Based_Infant_Respiration_Estimation/air-400/cache_pose_glsa_debug"

echo "=========================================="
echo "Starting Pose GLSA Debug Run"
echo "Job ID: $SLURM_JOB_ID"
echo "Node: $(hostname)"
echo "Start time: $(date)"
echo "=========================================="

module load miniforge
source activate respenv

nvidia-smi

cd "$PROJECT_DIR" || exit 1

rm -rf "$CACHE_DIR"

echo "Running config:"
echo "$CONFIG_FILE"

python main.py --config "$CONFIG_FILE"

echo "=========================================="
echo "Finished at: $(date)"
echo "=========================================="