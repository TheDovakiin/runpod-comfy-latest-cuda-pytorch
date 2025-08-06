# RunPod Permanent ComfyUI Template - Latest CUDA & PyTorch

A **lightning-fast** RunPod template for ComfyUI with PyTorch 2.7.1 and CUDA 12.8 support. Built on **RunPod-optimized base images** for **zero massive downloads**.

## Features

- **🚀 ZERO MASSIVE DOWNLOADS**: Uses RunPod-cached base image (no more 4GB downloads!)
- **⚡ Instant startup**: Pre-cached base eliminates PyTorch/CUDA download time
- **PyTorch 2.7.1** with **CUDA 12.8** support
- **ComfyUI** with ComfyUI-Manager **pre-installed** (no downloads on first run!)
- **JupyterLab** pre-installed with data science packages
- **Enhanced terminal experience** with autocomplete, better prompt, and helpful aliases
- **Essential utilities**: zip, htop, tree, tmux, screen, vim, and more
- **Network persistence** - everything stored in RunPod network storage
- **Helper scripts** for easy management
- **Dual web interfaces**: ComfyUI on port 8188, JupyterLab on port 8888

## 🚀 Performance Revolution

This template now uses `ashleykleynhans/runpod-base:py311-cu128-torch271` instead of the standard PyTorch image. This **eliminates the massive 4GB+ downloads** that were happening every pod start:

- **Before**: Downloaded 4.18GB PyTorch/CUDA layers every time
- **After**: RunPod has this base image pre-cached = instant startup!
- **Startup Time**: Reduced from minutes to seconds

## Quick Start

### On RunPod

1. Use this Docker image: `kgabeci/runpod-comfy-latest:latest`
2. Set port mapping: `8188:8188,8888:8888`
3. ComfyUI will be available at `http://[your-pod-ip]:8188`
4. JupyterLab will be available at `http://[your-pod-ip]:8888`

### Local Development

```bash
docker build -t runpod-comfy-latest .
docker run -p 8188:8188 -p 8888:8888 -v ./workspace:/workspace runpod-comfy-latest
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

1. **Copies pre-installed ComfyUI** to network storage (no downloads!)
2. **Creates helper scripts** for easy management
3. **Ready to use immediately** - no waiting for dependency installations

### Enhanced Terminal Features

- **Tab completion** for commands and files
- **Colored prompt** showing current directory
- **Useful aliases**: `ll`, `la`, `l` for better file listing
- **Pre-installed utilities**: htop, tree, tmux, screen, vim, zip/unzip

## Helper Scripts

After first run, you'll find these scripts in `/workspace`:

- `run_gpu.sh` - Start ComfyUI with GPU acceleration
- `run_cpu.sh` - Start ComfyUI in CPU-only mode  
- `update_comfyui.sh` - Update ComfyUI and ComfyUI-Manager to latest versions
- `start_jupyter.sh` - Start JupyterLab on port 8888

## Port Configuration

- **8188**: ComfyUI web interface
- **8888**: JupyterLab interface (no password required)

## Volume Mapping

Mount `/workspace` to persist your ComfyUI installation, models, and outputs across container restarts.

## License

This template is provided as-is for convenience. ComfyUI and its dependencies are subject to their respective licenses.
