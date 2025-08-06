#!/bin/bash

# Set up better terminal experience
export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

# Ensure we're in the workspace directory (network storage)
cd /workspace

# First time setup - copy pre-installed ComfyUI from /opt to network storage
if [ ! -d "/workspace/ComfyUI" ]; then
    echo "🚀 First run detected. Setting up ComfyUI from pre-installed image..."
    
    # Copy pre-installed ComfyUI to network storage
    cp -r /opt/ComfyUI /workspace/
    
    echo "✅ ComfyUI copied to network storage (/workspace)"
    
    # Create helper scripts that work from network storage
    echo "#!/bin/bash" > run_gpu.sh
    echo "cd /workspace/ComfyUI" >> run_gpu.sh
    echo "python main.py --preview-method auto --listen --port 8188 --listen 0.0.0.0" >> run_gpu.sh
    chmod +x run_gpu.sh

    echo "#!/bin/bash" > run_cpu.sh
    echo "cd /workspace/ComfyUI" >> run_cpu.sh
    echo "python main.py --preview-method auto --listen --port 8188 --listen 0.0.0.0 --cpu" >> run_cpu.sh
    chmod +x run_cpu.sh
    
    # Create update script
    echo "#!/bin/bash" > update_comfyui.sh
    echo "cd /workspace/ComfyUI" >> update_comfyui.sh
    echo "git pull" >> update_comfyui.sh
    echo "cd custom_nodes/ComfyUI-Manager" >> update_comfyui.sh
    echo "git pull" >> update_comfyui.sh
    echo "echo '✅ ComfyUI updated'" >> update_comfyui.sh
    chmod +x update_comfyui.sh
    
    # Create JupyterLab startup script
    echo "#!/bin/bash" > start_jupyter.sh
    echo "cd /workspace" >> start_jupyter.sh
    echo "jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password=''" >> start_jupyter.sh
    chmod +x start_jupyter.sh
    
    echo "✅ Helper scripts created:"
    echo "  - run_gpu.sh: Start ComfyUI with GPU"
    echo "  - run_cpu.sh: Start ComfyUI with CPU only"
    echo "  - update_comfyui.sh: Update ComfyUI and ComfyUI-Manager"
    echo "  - start_jupyter.sh: Start JupyterLab on port 8888"
else
    echo "✅ ComfyUI found in network storage - ready to start!"
fi

# Ensure we always work from network storage
cd /workspace/ComfyUI

# Start JupyterLab in background
echo "🚀 Starting JupyterLab on port 8888..."
cd /workspace
nohup jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password='' > jupyter.log 2>&1 &

# Start ComfyUI
cd /workspace/ComfyUI
echo "🚀 Starting ComfyUI on port 8188..."
echo "🌐 Access ComfyUI at: http://[your-pod-ip]:8188"
echo "🔬 Access JupyterLab at: http://[your-pod-ip]:8888"
python main.py --preview-method auto --listen --port 8188