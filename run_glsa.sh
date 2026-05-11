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

# Go to project directory
cd /users/3/jian1105/Video-Based_Infant_Respiration_Estimation/air-400

# Load conda/miniforge
module load miniforge

# Activate environment
source activate respenv

# Optional: print GPU info
nvidia-smi

# Config list
CONFIGS=(
    "/users/3/jian1105/Video-Based_Infant_Respiration_Estimation/configs/train_size_test/efficientphys_6_fold_cv_air400_with_torso_roi_coarse2fine_of_body_train_pct100_glsa.yaml"
)

# Run configs
for CONFIG in "${CONFIGS[@]}"; do

    echo "========================================"
    echo "Running config:"
    echo "$CONFIG"
    echo "========================================"

    python main.py --config "$CONFIG"

    echo "Finished config:"
    echo "$CONFIG"
    echo "----------------------------------------"

done