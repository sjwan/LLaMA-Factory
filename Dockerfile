FROM nvidia/cuda:12.2.2-devel-ubuntu22.04 AS dev

RUN apt-get update -y \
    && apt-get install -y python3-pip git vim  curl iputils-ping

# Workaround for https://github.com/openai/triton/issues/2507 and
# https://github.com/pytorch/pytorch/issues/107960 -- hopefully
# this won't be needed for future versions of this docker image
# or future versions of triton.
RUN ldconfig /usr/local/cuda-12.4/compat/

WORKDIR /app

COPY requirements.txt /app/

RUN mkdir -p /root/.config/vllm/nccl/cu12

RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt

COPY . /app/
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -e .[metrics,bitsandbytes,qwen]

VOLUME [ "/root/.cache/huggingface/", "/app/data", "/app/output" ]
EXPOSE 7860

CMD [ "llamafactory-cli", "webui" ]
