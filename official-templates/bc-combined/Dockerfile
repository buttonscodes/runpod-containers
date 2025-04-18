FROM runpod/base:0.4.0-cuda12.1.0

ARG COMFYUI_VERSION

# Create model directories
RUN mkdir -p /ComfyUI/models/{checkpoints,clip,clip_vision,controlnet,diffusers,embeddings,loras,upscale_models,vae}

# Install additional system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    git-lfs \
    zsh \
    htop \
    vim.tiny \
    expect \
    gnome-keyring \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup Python and pip symlinks
RUN ln -sf /usr/bin/python3.10 /usr/bin/python && \
    ln -sf /usr/bin/python3.10 /usr/bin/python3 && \
    python -m pip install --upgrade pip && \
    ln -sf /usr/local/bin/pip3.10 /usr/local/bin/pip

# Install Node.js for DiscoArt UI
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Install VS Code Server
ENV VSCODE_SERVE_MODE=remote
RUN wget -q -O- https://aka.ms/install-vscode-server/setup.sh | sh

# Copy VS Code server scripts
COPY --from=runpod/vscode-server:latest /usr/local/bin/init /usr/local/bin/
COPY --from=runpod/vscode-server:latest /usr/local/bin/serve-local /usr/local/bin/
COPY --from=runpod/vscode-server:latest /usr/local/bin/serve-remote /usr/local/bin/
COPY --from=runpod/vscode-server:latest /usr/local/bin/start-vscode /usr/local/bin/

# Install ComfyUI and ComfyUI Manager
RUN cd /ComfyUI && \
    git init && \
    git remote add origin https://github.com/comfyanonymous/ComfyUI.git && \
    git fetch --depth 1 origin tag ${COMFYUI_VERSION} && \
    git checkout FETCH_HEAD && \
    pip install -r requirements.txt && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager && \
    cd custom_nodes/ComfyUI-Manager && \
    pip install -r requirements.txt

# Install additional AI/ML packages
RUN pip install \
    diffusers \
    accelerate \
    transformers \
    torch \
    torchvision \
    torchaudio \
    numpy \
    isoduration \
    jsonschema[format] \
    jupyterlab \
    ipywidgets \
    jupyter-archive \
    jupyter_contrib_nbextensions \
    discoart==0.12.0

# Setup Jupyter extensions
RUN jupyter contrib nbextension install --user && \
    jupyter nbextension enable varInspector/main && \
    jupyter nbextension enable --py widgetsnbextension

# Install DiscoArt UI
RUN cd / && \
    git clone https://github.com/Run-Pod/discoart-ui.git && \
    cd discoart-ui && \
    npm install

# Setup DiscoArt environment
ENV DISCOART_OPTOUT_CLOUD_BACKUP='1'
ENV DISCOART_OUTPUT_DIR='/workspace/out'

# Create workspace and output directories
RUN mkdir -p /workspace/out

# Create user directory to store logs
RUN mkdir -p /ComfyUI/user

# Copy configuration files
COPY README.md /usr/share/nginx/html/README.md
COPY extra_model_paths.yml /ComfyUI/extra_model_paths.yml
COPY pre_start.sh /pre_start.sh
COPY post_start.sh /post_start.sh
RUN chmod +x /pre_start.sh /post_start.sh

LABEL maintainer="BC Team"
LABEL version="1.0.0"
LABEL description="Combined AI Image Generation Environment with ComfyUI, DiscoArt, and VS Code Server"

CMD [ "/start.sh" ]