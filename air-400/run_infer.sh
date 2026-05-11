#!/bin/bash -l

#SBATCH --job-name=air400
#SBATCH --partition=msigpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=10
#SBATCH --mem=120G
#SBATCH --time=08:00:00
#SBATCH --output=output.log
#SBATCH --error=error.log

export PYTHONPATH=$PYTHONPATH:.
#export WANDB_DIR=/scratch/song.liy/wandb
#export WANDB_CACHE_DIR=/scratch/song.liy/.cache/wandb
#export WANDB_DATA_DIR=/scratch/song.liy/.cache/wandb-data
export CUBLAS_WORKSPACE_CONFIG=":4096:8"  # For reproducibility
export PYTHONHASHSEED="42"  # For reproducibility

# Activate env (MSI version)
module load miniforge
source activate respenv

# Go to project directory (important)
cd ~/air-400

CONFIG="configs/inference/deepphys_deep_infer.yaml"
CHECKPOINT="model_checkpoints/DeepPhys_Deep_Body_best.pth"

echo "Running config: $CONFIG with model: $CHECKPOINT"
python infer.py --config "$CONFIG" --checkpoint "$CHECKPOINT"
echo "Finished config: $CONFIG"