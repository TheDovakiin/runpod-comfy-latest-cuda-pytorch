#!/bin/bash

# Set up better terminal experience
export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

# CRITICAL: Configure pip to use network storage for ALL installations
export PYTHONUSERBASE="/workspace/.local"
export PATH="/workspace/.local/bin:$PATH"
export PIP_CACHE_DIR="/workspace/.pip-cache"
export PIP_USER=1

# Create necessary directories in network storage
mkdir -p /workspace/.local/lib/python3.11/site-packages
mkdir -p /workspace/.local/bin
mkdir -p /workspace/.pip-cache

# Ensure we're in the workspace directory (network storage)
cd /workspace

# First time setup - copy pre-installed ComfyUI from /opt to network storage
if [ ! -d "/workspace/ComfyUI" ]; then
    echo "🚀 First run detected. Setting up ComfyUI from pre-installed image..."
    
    # Copy pre-installed ComfyUI to network storage
    cp -r /opt/ComfyUI /workspace/
    
    echo "✅ ComfyUI copied to network storage (/workspace)"
    
    # Install utilities to network storage from pre-cached sources (ZERO downloads!)
    echo "🚀 Installing terminal utilities from PRE-CACHED sources to network storage..."
    mkdir -p /workspace/.local/bin
    mkdir -p /workspace/.cache/sources
    cd /workspace/.cache/sources
    
    # Pre-download ALL sources to network storage if not cached
    if [ ! -f "node-v20.11.0-linux-x64.tar.xz" ]; then
        echo "📦 Pre-caching Node.js source..."
        wget -q https://nodejs.org/dist/v20.11.0/node-v20.11.0-linux-x64.tar.xz
    fi
    
    if [ ! -f "htop-3.3.0.tar.xz" ]; then
        echo "📦 Pre-caching htop source..."
        wget -q https://github.com/htop-dev/htop/releases/download/3.3.0/htop-3.3.0.tar.xz
    fi
    
    if [ ! -f "tree-2.1.1.tgz" ]; then
        echo "📦 Pre-caching tree source..."
        wget -q http://mama.indstate.edu/users/ice/tree/src/tree-2.1.1.tgz
    fi
    
    if [ ! -f "tmux-3.4.tar.gz" ]; then
        echo "📦 Pre-caching tmux source..."
        wget -q https://github.com/tmux/tmux/releases/download/3.4/tmux-3.4.tar.gz
    fi
    
    if [ ! -f "screen-4.9.1.tar.gz" ]; then
        echo "📦 Pre-caching screen source..."
        wget -q https://ftp.gnu.org/gnu/screen/screen-4.9.1.tar.gz
    fi
    
    echo "✅ All sources cached to network storage!"
    
    # Now install from cached sources (NO downloads!)
    cd /workspace/.local/bin
    
    # Install Node.js from cache
    if [ ! -f node ]; then
        echo "🚀 Installing Node.js from cache..."
        tar -xf /workspace/.cache/sources/node-v20.11.0-linux-x64.tar.xz --strip-components=1
        echo "✅ Node.js installed"
    fi
    
    # Install zip from system packages
    if [ ! -f zip ]; then
        echo "🚀 Installing zip..."
        apt-get download zip >/dev/null 2>&1 && dpkg-deb -x zip_*.deb . && rm zip_*.deb
        mv usr/bin/zip . 2>/dev/null || true
        rm -rf usr 2>/dev/null || true
        echo "✅ zip installed"
    fi
    
    # Install vim from system packages
    if [ ! -f vim ]; then
        echo "🚀 Installing vim..."
        apt-get download vim >/dev/null 2>&1 && dpkg-deb -x vim_*.deb . && rm vim_*.deb
        mv usr/bin/vim . 2>/dev/null || true
        rm -rf usr 2>/dev/null || true
        echo "✅ vim installed"
    fi
    
    # Install htop from cached source
    if [ ! -f htop ]; then
        echo "🚀 Installing htop from cache..."
        cd /tmp
        tar -xf /workspace/.cache/sources/htop-3.3.0.tar.xz
        cd htop-3.3.0
        ./configure --prefix=/workspace/.local --disable-unicode >/dev/null 2>&1
        make -j$(nproc) >/dev/null 2>&1
        make install >/dev/null 2>&1
        cd /workspace/.local/bin
        rm -rf /tmp/htop-3.3.0*
        echo "✅ htop installed"
    fi
    
    # Install tree from cached source
    if [ ! -f tree ]; then
        echo "🚀 Installing tree from cache..."
        cd /tmp
        tar -xf /workspace/.cache/sources/tree-2.1.1.tgz
        cd tree-2.1.1
        make >/dev/null 2>&1
        cp tree /workspace/.local/bin/
        cd /workspace/.local/bin
        rm -rf /tmp/tree-2.1.1*
        echo "✅ tree installed"
    fi
    
    # Install tmux from cached source
    if [ ! -f tmux ]; then
        echo "🚀 Installing tmux from cache..."
        cd /tmp
        tar -xf /workspace/.cache/sources/tmux-3.4.tar.gz
        cd tmux-3.4
        ./configure --prefix=/workspace/.local >/dev/null 2>&1
        make -j$(nproc) >/dev/null 2>&1
        make install >/dev/null 2>&1
        cd /workspace/.local/bin
        rm -rf /tmp/tmux-3.4*
        echo "✅ tmux installed"
    fi
    
    # Install screen from cached source
    if [ ! -f screen ]; then
        echo "🚀 Installing screen from cache..."
        cd /tmp
        tar -xf /workspace/.cache/sources/screen-4.9.1.tar.gz
        cd screen-4.9.1
        ./configure --prefix=/workspace/.local >/dev/null 2>&1
        make -j$(nproc) >/dev/null 2>&1
        make install >/dev/null 2>&1
        cd /workspace/.local/bin
        rm -rf /tmp/screen-4.9.1*
        echo "✅ screen installed"
    fi
    
    cd /workspace
    echo "🚀 ALL UTILITIES INSTALLED FROM CACHED SOURCES!"
    echo "📁 Utilities: /workspace/.local/bin"
    echo "📁 Sources cache: /workspace/.cache/sources"
    echo "💾 Everything persists - ZERO downloads on next pod start!"
    
    # Pre-cache common pip packages to network storage (eliminate ALL downloads!)
    echo "📦 Pre-caching common Python packages to network storage..."
    mkdir -p /workspace/.pip-cache
    export PIP_CACHE_DIR="/workspace/.pip-cache"
    export PIP_USER=1
    export PYTHONUSERBASE="/workspace/.local"
    export PATH="/workspace/.local/bin:$PATH"
    
    # Pre-download common packages that custom nodes often need
    pip download --dest /workspace/.pip-cache \
        opencv-python \
        pillow \
        numpy \
        scipy \
        scikit-image \
        matplotlib \
        seaborn \
        requests \
        aiohttp \
        websockets \
        psutil \
        GPUtil \
        tqdm \
        pyyaml \
        packaging \
        typing-extensions \
        filelock \
        jinja2 \
        networkx \
        sympy \
        >/dev/null 2>&1 || true
    
    echo "✅ Common Python packages cached to /workspace/.pip-cache"
    echo "💾 Future pip installs will use cached packages = INSTANT!"
    
    # Environment is configured - all future pip installs will go to network storage automatically
    
    # Create helper scripts that work from network storage
    echo "#!/bin/bash" > run_gpu.sh
    echo "export PYTHONUSERBASE=\"/workspace/.local\"" >> run_gpu.sh
    echo "export PATH=\"/workspace/.local/bin:\$PATH\"" >> run_gpu.sh
    echo "export PIP_USER=1" >> run_gpu.sh
    echo "cd /workspace/ComfyUI" >> run_gpu.sh
    echo "python main.py --preview-method auto --listen --port 8188" >> run_gpu.sh
    chmod +x run_gpu.sh

    echo "#!/bin/bash" > run_cpu.sh
    echo "export PYTHONUSERBASE=\"/workspace/.local\"" >> run_cpu.sh
    echo "export PATH=\"/workspace/.local/bin:\$PATH\"" >> run_cpu.sh
    echo "export PIP_USER=1" >> run_cpu.sh
    echo "cd /workspace/ComfyUI" >> run_cpu.sh
    echo "python main.py --preview-method auto --listen --port 8188 --cpu" >> run_cpu.sh
    chmod +x run_cpu.sh
    
    # Create update script
    echo "#!/bin/bash" > update_comfyui.sh
    echo "cd /workspace/ComfyUI" >> update_comfyui.sh
    echo "git pull" >> update_comfyui.sh
    echo "cd custom_nodes/ComfyUI-Manager" >> update_comfyui.sh
    echo "git pull" >> update_comfyui.sh
    echo "echo '✅ ComfyUI updated'" >> update_comfyui.sh
    chmod +x update_comfyui.sh
    
    # Create JupyterLab startup script with terminal utilities
    echo "#!/bin/bash" > start_jupyter.sh
    echo "export PYTHONUSERBASE=\"/workspace/.local\"" >> start_jupyter.sh
    echo "export PATH=\"/workspace/.local/bin:\$PATH\"" >> start_jupyter.sh
    echo "cd /workspace" >> start_jupyter.sh
    echo "echo 'Starting JupyterLab with enhanced terminal on port 8888...'" >> start_jupyter.sh
    echo "echo '✅ Utilities in NETWORK STORAGE: htop, tree, tmux, screen, vim, zip, nodejs, npm'" >> start_jupyter.sh
    echo "echo '✅ Location: /workspace/.local/bin (persists across restarts!)'" >> start_jupyter.sh
    echo "echo '✅ Tab completion and aliases enabled'" >> start_jupyter.sh
    echo "echo '✅ Enhanced prompt with current directory'" >> start_jupyter.sh
    echo "echo '🧪 Test utilities with: ./test_utilities.sh'" >> start_jupyter.sh
    echo "jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --ServerApp.token='' --ServerApp.password='' --ServerApp.disable_check_xsrf=True" >> start_jupyter.sh
    chmod +x start_jupyter.sh
    
    # Create dependency installer script
    echo "#!/bin/bash" > install_custom_deps.sh
    echo "export PYTHONUSERBASE=\"/workspace/.local\"" >> install_custom_deps.sh
    echo "export PATH=\"/workspace/.local/bin:\$PATH\"" >> install_custom_deps.sh
    echo "export PIP_CACHE_DIR=\"/workspace/.pip-cache\"" >> install_custom_deps.sh
    echo "export PIP_USER=1" >> install_custom_deps.sh
    echo "echo 'Scanning custom nodes for dependencies...'" >> install_custom_deps.sh
    echo "find /workspace/ComfyUI/custom_nodes -name 'requirements.txt' -exec pip install --user -r {} \;" >> install_custom_deps.sh
    echo "echo '✅ All custom node dependencies installed to network storage'" >> install_custom_deps.sh
    chmod +x install_custom_deps.sh
    
    # Create terminal utilities test script
    echo "#!/bin/bash" > test_utilities.sh
    echo "export PATH=\"/workspace/.local/bin:\$PATH\"" >> test_utilities.sh
    echo "echo '🧪 Testing Terminal Utilities from Network Storage...'" >> test_utilities.sh
    echo "echo ''" >> test_utilities.sh
    echo "echo '📍 Current Location:' && pwd" >> test_utilities.sh
    echo "echo ''" >> test_utilities.sh
    echo "echo '📁 Directory listing (ll):' && ll" >> test_utilities.sh
    echo "echo ''" >> test_utilities.sh
    echo "echo '🌳 Tree utility (/workspace/.local/bin/tree):' && /workspace/.local/bin/tree -L 1 ." >> test_utilities.sh
    echo "echo ''" >> test_utilities.sh
    echo "echo '⚡ htop version (/workspace/.local/bin/htop):' && /workspace/.local/bin/htop --version 2>/dev/null || echo 'htop installed'" >> test_utilities.sh
    echo "echo '✏️ vim version (/workspace/.local/bin/vim):' && /workspace/.local/bin/vim --version 2>/dev/null | head -1 || echo 'vim installed'" >> test_utilities.sh
    echo "echo '📦 zip version (/workspace/.local/bin/zip):' && /workspace/.local/bin/zip --version 2>/dev/null | head -1 || echo 'zip installed'" >> test_utilities.sh
    echo "echo '🟢 Node.js version (/workspace/.local/bin/node):' && /workspace/.local/bin/node --version" >> test_utilities.sh
    echo "echo '📦 npm version (/workspace/.local/bin/npm):' && /workspace/.local/bin/npm --version" >> test_utilities.sh
    echo "echo '🛠️ tmux version (/workspace/.local/bin/tmux):' && /workspace/.local/bin/tmux -V" >> test_utilities.sh
    echo "echo '🖥️ screen version (/workspace/.local/bin/screen):' && /workspace/.local/bin/screen --version 2>/dev/null | head -1 || echo 'screen installed'" >> test_utilities.sh
    echo "echo ''" >> test_utilities.sh
    echo "echo '✅ All utilities installed to NETWORK STORAGE!'" >> test_utilities.sh
    echo "echo '📁 Location: /workspace/.local/bin'" >> test_utilities.sh
    echo "echo 'ℹ️ Available aliases: ll, la, l, cls, .., ...'" >> test_utilities.sh
    echo "echo 'ℹ️ Tab completion should work - try typing \"cd \" and press Tab'" >> test_utilities.sh
    echo "echo 'ℹ️ These utilities persist across pod restarts!'" >> test_utilities.sh
    chmod +x test_utilities.sh
    
    echo "✅ Helper scripts created:"
    echo "  - run_gpu.sh: Start ComfyUI with GPU"
    echo "  - run_cpu.sh: Start ComfyUI with CPU only"
    echo "  - update_comfyui.sh: Update ComfyUI and ComfyUI-Manager"
    echo "  - start_jupyter.sh: Start JupyterLab on port 8888"
    echo "  - install_custom_deps.sh: Install all custom node dependencies"
    echo "  - test_utilities.sh: Test terminal utilities in JupyterLab"
else
    echo "✅ ComfyUI found in network storage - ready to start!"
fi

# ALWAYS set environment for network storage Python packages
export PYTHONUSERBASE="/workspace/.local"
export PATH="/workspace/.local/bin:$PATH"
export PIP_CACHE_DIR="/workspace/.pip-cache"
export PIP_USER=1

# Start JupyterLab in background with proper environment
echo "🚀 Starting JupyterLab on port 8888..."
cd /workspace

# Create JupyterLab config file with terminal utilities enabled
mkdir -p ~/.jupyter
cat > ~/.jupyter/jupyter_lab_config.py << EOF
c.ServerApp.ip = '0.0.0.0'
c.ServerApp.port = 8888
c.ServerApp.open_browser = False
c.ServerApp.allow_root = True
c.ServerApp.token = ''
c.ServerApp.password = ''
c.ServerApp.disable_check_xsrf = True
c.ServerApp.allow_origin = '*'
c.ServerApp.allow_remote_access = True
c.ServerApp.terminado_settings = {'shell_command': ['/bin/bash', '-l']}
c.ServerApp.terminals_enabled = True
EOF

# Ensure bash completion and utilities are loaded for JupyterLab terminals
echo '# JupyterLab terminal configuration' >> ~/.bashrc
echo 'export TERM=xterm-256color' >> ~/.bashrc
echo 'complete -cf sudo' >> ~/.bashrc

# Create global bashrc link for all users in JupyterLab
if [ ! -f /etc/bash.bashrc ]; then
    ln -sf ~/.bashrc /etc/bash.bashrc
fi

# Start JupyterLab with proper configuration
nohup jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --ServerApp.token='' --ServerApp.password='' --ServerApp.disable_check_xsrf=True > jupyter.log 2>&1 &

# Wait for JupyterLab to start
sleep 5

# Check if JupyterLab is actually running and accessible
if pgrep -f "jupyter-lab" > /dev/null; then
    echo "✅ JupyterLab started successfully!"
else
    echo "❌ JupyterLab failed to start, check jupyter.log"
fi

# Start ComfyUI
cd /workspace/ComfyUI
echo "🚀 Starting ComfyUI on port 8188..."
echo "🌐 Access ComfyUI at: http://[your-pod-ip]:8188"
echo "🔬 Access JupyterLab at: http://[your-pod-ip]:8888"
python main.py --preview-method auto --listen --port 8188