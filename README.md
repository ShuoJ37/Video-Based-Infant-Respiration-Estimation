# Video Based Infant Respiration Estimation

Workspace for video-based infant analysis experiments. The repository combines:

- `air-400/`: infant respiration waveform and respiration-rate estimation from video.
- `Infant-Pose-Estimation/`: Fine-tuned Domain-adapted Infant Pose (FiDIP) pose estimation code.
- `yolo/`: a small Ultralytics YOLO pose-estimation demo over a sample AIR-400 video.
- `configs/`: local experiment configs, including GLSA training variants.
- `run_glsa*.sh`: SLURM launch scripts for selected AIR-400/GLSA experiments.

The two main subprojects are research codebases with their own READMEs:

- [AIR-400 README](air-400/README.md)
- [FiDIP README](Infant-Pose-Estimation/README.md)

## Repository Layout

```text
vedio_basic/
├── air-400/                 # AIR-400 respiration estimation code
│   ├── configs/             # training, inference, ROI, and reproduction configs
│   ├── dataloaders/         # AIR-125, AIR-400, COHFACE, and inference datasets
│   ├── models/              # DeepPhys, TSCAN, EfficientPhys, VIRENet
│   ├── processors/          # preprocessing and postprocessing utilities
│   ├── trainers/            # model training loop
│   ├── main.py              # training/evaluation entry point
│   ├── infer.py             # pretrained-model inference entry point
│   └── environment.yml      # Conda environment for AIR-400
├── Infant-Pose-Estimation/  # FiDIP infant pose estimation project
├── yolo/                    # YOLO pose demo and example video/output
├── configs/                 # local AIR-400 experiment configs
├── run_glsa.sh              # full GLSA SLURM run
├── run_glsa_debug.sh        # debug GLSA SLURM run
└── run_glsa_small.sh        # smaller GLSA SLURM run
```

## Requirements

This project expects a Linux environment with NVIDIA GPU support for training and most inference workflows.

For the AIR-400 respiration code:

- Conda or Miniforge
- Python 3.9.18
- CUDA-compatible PyTorch
- OpenCV, h5py, tqdm, wandb, ultralytics, imageio, av, cython

The AIR-400 environment is defined in `air-400/environment.yml`.

For FiDIP pose estimation, see `Infant-Pose-Estimation/fidip_env.yml` and the setup notes in `Infant-Pose-Estimation/README.md`.

## AIR-400 Setup

From the repository root:

```bash
cd air-400
conda env create -f environment.yml
conda activate respenv
```

AIR-400 also requires the `pyflow` optical-flow extension for configs that use coarse-to-fine optical flow:

```bash
git clone https://github.com/pathak22/pyflow.git
cd pyflow
python setup.py build_ext -i
mv pyflow.cpython-*.so ..
cd ..
```

Download the required datasets, model checkpoints, and ROI detector weights from the links in `air-400/README.md`.

## AIR-400 Inference

Edit one config under `air-400/configs/inference/` and set the paths in `DATA_PATH`, especially:

- `OUTPUT_DIR`
- `VIDEO_FILE` or `VIDEO_DIR`
- `BODY_DETECTOR_PATH` and `FACE_DETECTOR_PATH`, if ROI cropping is enabled

Then run inference from `air-400/`:

```bash
python infer.py \
  --config configs/inference/deepphys_deep_infer.yaml \
  --checkpoint model_checkpoints/DeepPhys_Deep_Body_best.pth
```

The helper script `air-400/run_infer.sh` wraps the same command for SLURM, but it contains machine-specific paths. Update `cd ~/air-400`, `CONFIG`, and `CHECKPOINT` before submitting it.

Expected inference outputs are written below:

```text
<OUTPUT_DIR>/inference/
<OUTPUT_DIR>/logs/
```

Each processed video gets a result JSON, predicted respiration waveform HDF5, waveform plot PNG, and the run also writes a summary JSON.

## AIR-400 Training

Training uses `air-400/main.py`:

```bash
cd air-400
python main.py --config configs/train_size_test/efficientphys_6_fold_cv_air400_with_roi_coarse2fine_of_body_train_pct100.yaml
```

Before running, edit the selected YAML config and set the dataset and output paths in `DATA_PATH`, including:

- `AIR_125`
- `AIR_400`
- `COHFACE`, if used by that config
- `CACHE_DIR`
- `OUTPUT_DIR`
- ROI detector paths, if cropping is enabled

For SLURM runs, update the hard-coded project paths in these scripts before submitting:

```bash
sbatch run_glsa.sh
sbatch run_glsa_debug.sh
sbatch run_glsa_small.sh
```

## FiDIP Pose Estimation

The FiDIP project lives in `Infant-Pose-Estimation/`.

Basic setup:

```bash
cd Infant-Pose-Estimation
conda env create -f fidip_env.yml
conda activate fidip
cd lib
make
```

Download the pretrained FiDIP and backbone models described in `Infant-Pose-Estimation/README.md`, then place them under `Infant-Pose-Estimation/models/`.

Example validation command from the FiDIP README:

```bash
python tools/test_adaptive_model.py \
  --cfg experiments/coco/hrnet/w48_384x288_adam_lr1e-3_infant.yaml \
  TEST.MODEL_FILE models/hrnet_fidip.pth \
  TEST.USE_GT_BBOX True
```

## YOLO Pose Demo

The script `yolo/pose-estimation-yolo26.py` runs Ultralytics YOLO pose inference on `yolo/video/demo-air-400-s05-23.mp4`:

```bash
cd yolo
python pose-estimation-yolo26.py
```

The script expects `yolo26m-pose.pt` to be available in the working directory or resolvable by Ultralytics. Outputs are saved under `yolo/runs/pose/`.

## Notes

- Several scripts currently contain absolute paths from another environment, such as `/users/3/jian1105/...`. Replace them with paths under your workspace before running.
- Large datasets, trained checkpoints, generated caches, model outputs, and W&B logs should stay out of git.
- This repository includes third-party research code. Check each subproject's README and license before redistributing code, models, or datasets.

## Citations

If you use the respiration-estimation code or AIR-400 dataset, cite the AIR-400 paper listed in `air-400/README.md`.

If you use the FiDIP pose-estimation code or models, cite the FiDIP paper listed in `Infant-Pose-Estimation/README.md`.
