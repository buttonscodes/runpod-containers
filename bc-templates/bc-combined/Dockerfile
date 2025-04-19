FROM runpod/base:0.6.2-cuda12.1.0

ARG COMFYUI_VERSION

# VS Code
EXPOSE 8080
# ComfyUI
EXPOSE 3000
# DiscoArt
EXPOSE 3333
# Jupyter
EXPOSE 8888
# Filebrowser
EXPOSE 4040

# Create workspace working directory
WORKDIR /workspace

# Install system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    dumb-init \
    expect \
    git \
    git-lfs \
    gnome-keyring \
    htop \
    locales \
    lsb-release \
    man \
    nano \
    openssh-client \
    procps \
    sudo \
    vim.tiny \
    zsh \
    && git lfs install \
    && sed -i "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen \
    && locale-gen \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Setup Python and pip symlinks
RUN ln -sf /usr/bin/python3.10 /usr/bin/python && \
    ln -sf /usr/bin/python3.10 /usr/bin/python3 && \
    python -m pip install --upgrade pip && \
    ln -sf /usr/local/bin/pip3.10 /usr/local/bin/pip

# Add coder user and set sudo permissions
RUN adduser --gecos '' --disabled-password coder \
    && echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

############### VS Code ##############

RUN curl -fsSL https://code-server.dev/install.sh | sh


############### ComfyUI ###############

# Create model directories
RUN mkdir -p /ComfyUI/models/{checkpoints,clip,clip_vision,controlnet,diffusers,embeddings,loras,upscale_models,vae}

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

# Create user directory to store logs
RUN mkdir -p /ComfyUI/user

############### DiscoArt ###############

# Install Node.js for DiscoArt UI
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Downgrade notebook to a compatible version
RUN pip install notebook==6.5.6

RUN pip install \
    numpy isoduration jsonschema[format]\
    torch==1.11.0+cu113 torchvision==0.12.0+cu113 torchaudio==0.11.0 --extra-index-url https://download.pytorch.org/whl/cu113 \
    jupyterlab ipywidgets jupyter-archive jupyter_contrib_nbextensions

# Install contrib extensions (for DiscoArt)
RUN jupyter contrib nbextension install --user && \
    jupyter nbextension enable varInspector/main && \
    jupyter nbextension enable --py widgetsnbextension

# Create workspace and output directories
RUN mkdir -p /workspace/discout
RUN mkdir -p /examples

# Add welcome banner
ADD welcome-banner.txt /root/welcome-banner.txt
COPY examples /examples
ADD welcome.ipynb /root/welcome.ipynb
RUN echo 'cat ~/welcome-banner.txt' >> ~/.bashrc &&\
    echo 'cd /workspace' >> ~/.bashrc

# Get discoart model config
RUN wget https://raw.githubusercontent.com/jina-ai/discoart/main/discoart/resources/models.yml -O /models.yaml

# Setup DiscoArt environment
ENV DISCOART_OPTOUT_CLOUD_BACKUP='1'
ENV DISCOART_OUTPUT_DIR='/workspace/discout'

WORKDIR /
RUN pip install discoart==0.12.0
RUN git clone https://github.com/Run-Pod/discoart-ui.git
WORKDIR /discoart-ui
RUN apt install nodejs
RUN npm install --global yarn
RUN yarn && yarn build
RUN yarn global add pm2

# Set DiscoArt port so it doesn't conflict with ComfyUI
RUN sed -i 's/-p 3000/-p 3333/g' package.json

# Create workspace and output directories
RUN mkdir -p /workspace/discout

############### Cleanup ###############

RUN rm -Rf /root/.cache && mkdir -p /models/.cache && ln -s /models/.cache /root

############### Start Scripts ###############

# NGINX Proxy
COPY --from=proxy nginx.conf /etc/nginx/nginx.conf
COPY --from=proxy readme.html /usr/share/nginx/html/readme.html

# Copy configuration files
COPY README.md /usr/share/nginx/html/README.md
COPY extra_model_paths.yml /ComfyUI/extra_model_paths.yml

# Start Scripts

COPY --from=scripts start.sh /
COPY pre_start.sh /pre_start.sh
COPY post_start.sh /post_start.sh
RUN chmod +x /pre_start.sh /post_start.sh /start.sh

LABEL maintainer="BC Team"
LABEL version="1.0.0"
LABEL description="Combined AI Image Generation Environment with ComfyUI, DiscoArt, and VS Code Server"

# Set user
USER 1000
ENV USER=coder
#WORKDIR /home/coder

CMD [ "/start.sh" ]