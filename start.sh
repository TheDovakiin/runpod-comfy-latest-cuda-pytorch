#!/bin/bash

# Set up better terminal experience
export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

cd /workspace

# First time setup - copy pre-installed ComfyUI from /opt to network storage
if [ ! -d "ComfyUI" ]; then
    echo "First run detected. Setting up ComfyUI from pre-installed image..."
    
    # Copy pre-installed ComfyUI to network storage
    cp -r /opt/ComfyUI /workspace/
    
    echo "✅ ComfyUI copied to network storage"
    
    # Create helper scripts that don't need venv since everything is pre-installed
    echo "#!/bin/bash" > run_gpu.sh
    echo "cd /workspace/ComfyUI" >> run_gpu.sh
    echo "python main.py --preview-method auto --listen --port 8188" >> run_gpu.sh
    chmod +x run_gpu.sh

    echo "#!/bin/bash" > run_cpu.sh
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
    
    echo "✅ Helper scripts created:"
    echo "  - run_gpu.sh: Start ComfyUI with GPU"
    echo "  - run_cpu.sh: Start ComfyUI with CPU only"
    echo "  - update_comfyui.sh: Update ComfyUI and ComfyUI-Manager"
else
    echo "✅ ComfyUI found in network storage"
fi

# Start ComfyUI
cd /workspace/ComfyUI
echo "🚀 Starting ComfyUI on port 8188..."
echo "🌐 Access ComfyUI at: http://[your-pod-ip]:8188"
python main.py --preview-method auto --listen --port 8188