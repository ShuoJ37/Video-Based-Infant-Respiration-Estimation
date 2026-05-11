#!/bin/bash
#SBATCH --job-name=efficientphys_glsa_6fold
#SBATCH --partition=msigpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --gres=gpu:1
#SBATCH --time=24:00:00
#SBATCH --output=efficientphys_glsa_6fold.out
#SBATCH --error=efficientphys_glsa_6fold.err

PROJECT_DIR="/users/3/jian1105/Video-Based_Infant_Respiration_Estimation/air-400"

CONFIG_FILE="/users/3/jian1105/Video-Based_Infant_Respiration_Estimation/configs/train_size_test/efficientphys_6_fold_cv_air400_with_torso_roi_coarse2fine_of_body_train_pct100_glsa.yaml"

# Go to project directory
cd "$PROJECT_DIR" || exit 1

# Load conda/miniforge
module load miniforge

# Activate environment
source activate respenv

nvidia-smi

echo "========================================"
echo "Running config:"
echo "$CONFIG_FILE"
echo "========================================"

python main.py --config "$CONFIG_FILE"

echo "Finished config:"
echo "$CONFIG_FILE"
echo "----------------------------------------"