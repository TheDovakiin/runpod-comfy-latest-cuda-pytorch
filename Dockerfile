FROM pytorch/pytorch:2.7.1-cuda12.8-cudnn9-runtime

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

# Set up better bash prompt and completion for all users
RUN echo 'export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "' >> /root/.bashrc && \
    echo 'source /etc/bash_completion' >> /root/.bashrc && \
    echo 'alias ll="ls -la"' >> /root/.bashrc && \
    echo 'alias la="ls -A"' >> /root/.bashrc && \
    echo 'alias l="ls -CF"' >> /root/.bashrc && \
    echo 'alias cls="clear"' >> /root/.bashrc && \
    echo 'alias ..="cd .."' >> /root/.bashrc && \
    echo 'alias ...="cd ../.."' >> /root/.bashrc

# Set up global bash configuration for all users (including JupyterLab terminal)
RUN echo 'export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "' >> /etc/bash.bashrc && \
    echo 'source /etc/bash_completion' >> /etc/bash.bashrc && \
    echo 'alias ll="ls -la"' >> /etc/bash.bashrc && \
    echo 'alias la="ls -A"' >> /etc/bash.bashrc && \
    echo 'alias l="ls -CF"' >> /etc/bash.bashrc && \
    echo 'alias cls="clear"' >> /etc/bash.bashrc && \
    echo 'alias ..="cd .."' >> /etc/bash.bashrc && \
    echo 'alias ...="cd ../.."' >> /etc/bash.bashrc

# Configure zsh for better terminal experience (JupyterLab might use zsh)
RUN echo 'export PS1="%F{green}%n@%m%f:%F{blue}%~%f$ "' >> /etc/zsh/zshrc && \
    echo 'alias ll="ls -la"' >> /etc/zsh/zshrc && \
    echo 'alias la="ls -A"' >> /etc/zsh/zshrc && \
    echo 'alias l="ls -CF"' >> /etc/zsh/zshrc && \
    echo 'alias cls="clear"' >> /etc/zsh/zshrc && \
    echo 'alias ..="cd .."' >> /etc/zsh/zshrc && \
    echo 'alias ...="cd ../.."' >> /etc/zsh/zshrc

# Set bash as default shell and ensure utilities are in PATH
RUN echo '/bin/bash' > /etc/shells && \
    update-alternatives --install /bin/sh sh /bin/bash 1

# Install JupyterLab and extensions
RUN python -m pip install --upgrade pip && \
    python -m pip install jupyterlab ipywidgets matplotlib seaborn plotly notebook && \
    jupyter lab --generate-config

# Configure JupyterLab to use bash terminal with all utilities
RUN mkdir -p /root/.jupyter && \
    echo "c.ServerApp.terminado_settings = {'shell_command': ['/bin/bash']}" >> /root/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.terminals_enabled = True" >> /root/.jupyter/jupyter_lab_config.py

# Create a global JupyterLab config that all users inherit
RUN mkdir -p /etc/jupyter && \
    echo "c.ServerApp.terminado_settings = {'shell_command': ['/bin/bash']}" >> /etc/jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.terminals_enabled = True" >> /etc/jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.allow_remote_access = True" >> /etc/jupyter/jupyter_lab_config.py

# Ensure PATH includes all utility directories for terminal sessions
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"

# Pre-install ComfyUI and dependencies to template location
RUN cd /opt && \
    git clone https://github.com/comfyanonymous/ComfyUI.git && \
    cd ComfyUI && \
    python -m pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128 && \
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