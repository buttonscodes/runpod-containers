#!/bin/bash

# Create model directories in workspace if they don't exist
mkdir -p /workspace/comfyui/models/{checkpoints,clip,clip_vision,controlnet,diffusers,embeddings,loras,upscale_models,vae,unet,configs}

# Create DiscoArt workspace if it doesn't exist
mkdir -p /workspace/discoart/out

# Create notebooks directory in workspace
mkdir -p /workspace/notebooks

# Set DiscoArt environment
export DISCOART_MODELS_YAML='/models.yaml'
export DISCOART_OUTPUT_DIR='/workspace/discoart/out'

# Start VS Code Server
code-server --accept-server-license-terms --host 0.0.0.0 --port 8000 >> /dev/stdout 2>&1 &

# Ensure VS Code Server started
sleep 2
if ! pgrep -f "code-server.*--port.*8000" > /dev/null; then
    echo "Failed to start VS Code Server"
    exit 1
fi

# Start ComfyUI service
cd /ComfyUI
nohup python main.py --listen --port 3000 >> /dev/stdout 2>&1 &

# Ensure ComfyUI started
sleep 2
if ! pgrep -f "python.*main.py.*--port.*3000" > /dev/null; then
    echo "Failed to start ComfyUI"
    exit 1
fi

# Start DiscoArt UI service
cd /discoart-ui
nohup npm start >> /dev/stdout 2>&1 &

# Ensure DiscoArt UI started
sleep 2
if ! pgrep -f "node.*start" > /dev/null; then
    echo "Failed to start DiscoArt UI"
    exit 1
fi

echo "All services started successfully:"
echo "- VS Code Server running on port 8000"
echo "- ComfyUI running on port 3000"
echo "- DiscoArt UI running on port 3001"
echo "Note: Jupyter Lab will start automatically if JUPYTER_PASSWORD is set"
