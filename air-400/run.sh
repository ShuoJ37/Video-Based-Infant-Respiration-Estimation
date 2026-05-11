#!/bin/bash -l

#SBATCH --job-name=efficientphys_air400
#SBATCH --partition=msigpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=10
#SBATCH --mem=120G
#SBATCH --time=24:00:00
#SBATCH --output=/users/3/jian1105/air-400/output/bash_logs/%x-%j.out
#SBATCH --error=/users/3/jian1105/air-400/output/error/%x-%j.err

export PYTHONPATH=$PYTHONPATH:.
#export WANDB_DIR=/scratch/song.liy/wandb
#export WANDB_CACHE_DIR=/scratch/song.liy/.cache/wandb
#export WANDB_DATA_DIR=/scratch/song.liy/.cache/wandb-data
export CUBLAS_WORKSPACE_CONFIG=":4096:8"  # For reproducibility
export PYTHONHASHSEED="42"  # For reproducibility

# Activate env
module load miniforge
source activate respenv
cd /users/3/jian1105/air-400

CONFIGS=(
    "/users/3/jian1105/air-400/configs/train_size_test/efficientphys_6_fold_cv_air400_with_roi_coarse2fine_of_body_train_pct100.yaml"
)

for CONFIG in "${CONFIGS[@]}"; do
    echo "Running training + evaluate for $CONFIG"
    python main.py --config "$CONFIG"
    
    echo "Finished config: $CONFIG"
    echo "----------------------------------------"
    
done

