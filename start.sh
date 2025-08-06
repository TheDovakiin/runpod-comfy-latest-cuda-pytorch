#!/bin/bash

cd /workspace

# First time setup
if [ ! -d "ComfyUI" ]; then
    echo "First run detected. Installing ComfyUI and dependencies..."

    git clone https://github.com/comfyanonymous/ComfyUI
    cd ComfyUI/custom_nodes
    git clone https://github.com/ltdrdata/ComfyUI-Manager comfyui-manager
    cd /workspace

    python3 -m venv venv
    source venv/bin/activate

    python -m pip install --upgrade pip
    python -m pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128
    python -m pip install -r ComfyUI/requirements.txt
    python -m pip install -r ComfyUI/custom_nodes/comfyui-manager/requirements.txt

    echo "#!/bin/bash" > run_gpu.sh
    echo "cd ComfyUI" >> run_gpu.sh
    echo "source /workspace/venv/bin/activate" >> run_gpu.sh
    echo "python main.py --preview-method auto" >> run_gpu.sh
    chmod +x run_gpu.sh

    echo "#!/bin/bash" > run_cpu.sh
    echo "cd ComfyUI" >> run_cpu.sh
    echo "source /workspace/venv/bin/activate" >> run_cpu.sh
    echo "python main.py --preview-method auto --cpu" >> run_cpu.sh
    chmod +x run_cpu.sh
fi

# Start ComfyUI
cd ComfyUI
source /workspace/venv/bin/activate
echo "Starting ComfyUI on port 8188..."
python main.py --preview-method auto --listen --port 8188