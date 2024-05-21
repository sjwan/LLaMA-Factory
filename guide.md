1. 创建容器



docker build -f ./Dockerfile -t llama-factory:latest .




2. 启动容器

docker run --runtime=nvidia --gpus all \
-v ./hf_cache:/root/.cache/huggingface/ \
-v ./data:/app/data \
-v ./examples:/app/examples \
-v ./output:/app/output \
-v ./saves:/app/saves \
-v ./modelscope:/root/.cache/modelscope/ \
-e CUDA_VISIBLE_DEVICES=0 \
-e USE_MODELSCOPE_HUB=1 \
-p 7860:7860 \
-p 7861:8888 \
--shm-size 16G \
--name llama_factory \
-d llama-factory:latest


3. 训练模型

CUDA_VISIBLE_DEVICES=0 llamafactory-cli train examples/lora_single_gpu/llama3_lora_sft.yaml


4. 模型推理

CUDA_VISIBLE_DEVICES=0 llamafactory-cli chat examples/inference/llama3_lora_sft.yaml


5. 模型导出

CUDA_VISIBLE_DEVICES=0 llamafactory-cli export examples/merge_lora/llama3_lora_sft.yaml


6. 生成 GGUF 模型

git clone https://github.com/ggerganov/llama.cpp.git
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r llama.cpp/requirements.txt


7. Ollama 导入模型

python llama.cpp/convert-hf-to-gguf.py /app/models/llama3_lora_sft/   --outfile test-llama3.gguf   --outtype q8_0



8. Ollama 运行模型

