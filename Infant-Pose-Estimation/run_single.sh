#!/bin/bash -l
#SBATCH --job-name=fidip_single
#SBATCH --partition=msigpu
#SBATCH --gres=gpu:1
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --output=fidip_single_%j.out
#SBATCH --error=fidip_single_%j.err

module load cuda/11.2
source activate fidip

cd ~/Infant-Pose-Estimation

python -c "import torch; print('cuda available:', torch.cuda.is_available()); print('cuda count:', torch.cuda.device_count())"

python tools/test_single.py