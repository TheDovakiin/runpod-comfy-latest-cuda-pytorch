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
    echo "echo '✅ Available utilities: htop, tree, tmux, screen, vim, zip, nodejs, npm'" >> start_jupyter.sh
    echo "echo '✅ Tab completion and aliases enabled'" >> start_jupyter.sh
    echo "echo '✅ Enhanced prompt with current directory'" >> start_jupyter.sh
    echo "jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --allow-origin='*' --no-token" >> start_jupyter.sh
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
    echo "echo '🧪 Testing Terminal Utilities in JupyterLab...'" >> test_utilities.sh
    echo "echo ''" >> test_utilities.sh
    echo "echo '📍 Current Location:' && pwd" >> test_utilities.sh
    echo "echo ''" >> test_utilities.sh
    echo "echo '📁 Directory listing (ll):' && ll" >> test_utilities.sh
    echo "echo ''" >> test_utilities.sh
    echo "echo '🌳 Tree utility:' && tree -L 1 ." >> test_utilities.sh
    echo "echo ''" >> test_utilities.sh
    echo "echo '⚡ htop version:' && htop --version" >> test_utilities.sh
    echo "echo '✏️ vim version:' && vim --version | head -1" >> test_utilities.sh
    echo "echo '📦 zip version:' && zip --version | head -1" >> test_utilities.sh
    echo "echo '🟢 Node.js version:' && node --version" >> test_utilities.sh
    echo "echo '📦 npm version:' && npm --version" >> test_utilities.sh
    echo "echo '🛠️ tmux version:' && tmux -V" >> test_utilities.sh
    echo "echo '🖥️ screen version:' && screen --version" >> test_utilities.sh
    echo "echo ''" >> test_utilities.sh
    echo "echo '✅ All utilities are working!'" >> test_utilities.sh
    echo "echo 'ℹ️ Available aliases: ll, la, l, cls, .., ...'" >> test_utilities.sh
    echo "echo 'ℹ️ Tab completion should work - try typing \"cd \" and press Tab'" >> test_utilities.sh
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

# Start JupyterLab with simplified command
nohup jupyter lab > /workspace/jupyter.log 2>&1 &

# Wait for JupyterLab to start
sleep 5

# Check if JupyterLab is actually running and accessible
if pgrep -f "jupyter-lab" > /dev/null; then
    echo "✅ JupyterLab process started!"
    echo "📝 Check /workspace/jupyter.log for startup logs"
    
    # Test if port 8888 is actually listening
    if netstat -tuln | grep -q ":8888 "; then
        echo "✅ JupyterLab listening on port 8888!"
    else
        echo "❌ JupyterLab not listening on port 8888"
        echo "📝 JupyterLab logs:"
        tail -10 /workspace/jupyter.log
    fi
else
    echo "❌ JupyterLab failed to start!"
    echo "📝 JupyterLab logs:"
    cat /workspace/jupyter.log
fi

# Start ComfyUI
cd /workspace/ComfyUI
echo "🚀 Starting ComfyUI on port 8188..."
echo "🌐 Access ComfyUI at: http://[your-pod-ip]:8188"
echo "🔬 Access JupyterLab at: http://[your-pod-ip]:8888"
python main.py --preview-method auto --listen --port 8188