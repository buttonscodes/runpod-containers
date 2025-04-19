# To Build

## From the project root:
docker buildx bake --file ./bc-templates/bc-combined/docker-bake.hcl

# To Run

docker run --rm -it buttonscodes/bc-combined:1.0.0 /bin/bash

# To Push

docker push buttonscodes/bc-combined:1.0.0

# RunPod Official Templates - Component Analysis

This document lists the main components installed in each Docker template.

## Base Images and Core Components

### Python Versions
- Python 3.10 (base, pytorch)
- Python 3.9 (tensorflow)

### CUDA/GPU Support
- CUDA 11.8
- CUDA 12.1

## Template-Specific Components

### Base Template
- Ubuntu 22.04
- Python 3.10
- CUDA 11.8
- Basic development tools
- RunPod SDK
- Jupyter Lab

### PyTorch Template
- Based on Base Template
- PyTorch
- torchvision
- torchaudio

### TensorFlow Template
- Based on Base Template
- TensorFlow
- Python 3.9

### Stable Diffusion WebUI Template
- Based on Base Template
- Stable Diffusion Web UI
- GFPGAN
- Real-ESRGAN
- LDSR

### ComfyUI Template
- Based on Base Template
- ComfyUI
- Git support
- Python packages for AI/ML

### InvokeAI Template
- Based on Base Template
- InvokeAI
- Git support

### Fast Stable Diffusion Template
- Based on Base Template
- Stable Diffusion
- Diffusers library
- Accelerate library

### DiscoArt Template
- Based on Base Template
- DiscoArt
- Git support

### Bittensor Template
- Based on Base Template
- Bittensor dependencies
- PM2 process manager

### VS Code Templates (vs-code & vscode-server)
- Based on Base Template
- VS Code Server (code-server)
- Additional development tools:
  - git and git-lfs
  - zsh shell
  - htop (process monitoring)
  - vim.tiny
  - man pages
  - locale support

### Oobabooga Template
- Based on Base Template
- Text generation web UI
- CUDA support
- Git support

## Common Components Across Templates
- Ubuntu 22.04 as base OS
- CUDA support
- System Utilities:
  - bash, curl, wget
  - git, rsync
  - vim, nano, tmux
  - nginx, openssh-server
  - zip, unzip
  - procps (process utilities)
  - inotify-tools
  - jq (JSON processor)
  - cifs-utils (for network filesystems)

- Development Tools:
  - build-essential
  - make, cmake
  - gfortran
  - libblas-dev, liblapack-dev (numerical computing)

- Media Processing Libraries:
  - ffmpeg
  - libavcodec, libavfilter, libavformat, libavutil
  - libjpeg, libpng, libtiff
  - libx264, libxvidcore (video codecs)
  - libv4l (video for linux)

- Deep Learning Dependencies:
  - libatlas-base-dev
  - libhdf5-serial-dev
  - libffi-dev
  - libssl-dev
  - libsm6
  - libgl1

- Python Environment:
  - pyenv for Python version management
  - pip package manager
  - Jupyter support

- RunPod SDK
- SSH server
