#!/bin/bash -l
#SBATCH --job-name=fidip_test
#SBATCH --partition=msigpu
#SBATCH --gres=gpu:1
#SBATCH --time=01:00:00
#SBATCH --mem=8G

module load cuda/11.2
source activate fidip

cd ~/Infant-Pose-Estimation

python tools/test_adaptive_model.py \
--cfg experiments/coco/hrnet/w48_384x288_adam_lr1e-3_infant.yaml \
TEST.MODEL_FILE models/hrnet_fidip.pth \
TEST.USE_GT_BBOX True