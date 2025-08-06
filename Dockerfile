FROM ashleykleynhans/runpod-base:py311-cu128-torch271

ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install essential packages
RUN apt-get update && apt-get install -y \
    git \
    python3-venv \
    python3-pip \
    wget \
    curl \
    unzip \
    zip \
    nano \
    vim \
    htop \
    tree \
    bash-completion \
    zsh \
    tmux \
    screen \
    ffmpeg \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    nodejs \
    npm \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Oh My Zsh for better terminal experience
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Set up better bash prompt and completion
RUN echo 'export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "' >> /root/.bashrc && \
    echo 'source /etc/bash_completion' >> /root/.bashrc && \
    echo 'alias ll="ls -la"' >> /root/.bashrc && \
    echo 'alias la="ls -A"' >> /root/.bashrc && \
    echo 'alias l="ls -CF"' >> /root/.bashrc

# Install additional packages (base image already has JupyterLab)
RUN python -m pip install --upgrade pip && \
    python -m pip install ipywidgets matplotlib seaborn plotly

# Pre-install ComfyUI and dependencies to template location
RUN cd /opt && \
    git clone https://github.com/comfyanonymous/ComfyUI.git && \
    cd ComfyUI && \
    python -m pip install -r requirements.txt

# Install ComfyUI-Manager
RUN cd /opt/ComfyUI/custom_nodes && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git && \
    cd ComfyUI-Manager && \
    python -m pip install -r requirements.txt

WORKDIR /workspace

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8188 8888

CMD ["/start.sh"]