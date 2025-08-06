# RunPod Permanent ComfyUI Template - Latest CUDA & PyTorch

A RunPod template for ComfyUI with the latest PyTorch 2.7.1 and CUDA 12.8 support.

## Features

- **PyTorch 2.7.1** with **CUDA 12.8** support
- **ComfyUI** with ComfyUI-Manager pre-installed
- Persistent storage support for RunPod
- Automatic setup on first run
- Web interface on port 8188

## Quick Start

### On RunPod

1. Use this Docker image: `[YOUR_DOCKERHUB_USERNAME]/runpod-comfy-latest:latest`
2. Set port mapping: `8188:8188`
3. ComfyUI will be available at `http://[your-pod-ip]:8188`

### Local Development

```bash
docker build -t runpod-comfy-latest .
docker run -p 8188:8188 -v ./workspace:/workspace runpod-comfy-latest
```

## System Requirements

- NVIDIA GPU with CUDA 12.8+ support
- Driver version 555+ (for data center GPUs, 470.57+ may work)
- At least 8GB GPU memory recommended

## Technical Details

- **Base Image**: `pytorch/pytorch:2.7.1-cuda12.8-cudnn9-runtime`
- **Python**: 3.10 (from base image)
- **CUDA**: 12.8
- **cuDNN**: 9
- **ComfyUI**: Latest from main branch
- **ComfyUI-Manager**: Latest from main branch

## First Run Setup

The container automatically:

1. Clones ComfyUI and ComfyUI-Manager
2. Creates a Python virtual environment
3. Installs PyTorch with CUDA 12.8 support
4. Installs all required dependencies
5. Creates helper scripts for GPU/CPU operation

## Helper Scripts

After first run, you'll find these scripts in `/workspace`:

- `run_gpu.sh` - Start ComfyUI with GPU acceleration
- `run_cpu.sh` - Start ComfyUI in CPU-only mode

## Port Configuration

- **8188**: ComfyUI web interface

## Volume Mapping

Mount `/workspace` to persist your ComfyUI installation, models, and outputs across container restarts.

## License

This template is provided as-is for convenience. ComfyUI and its dependencies are subject to their respective licenses.
