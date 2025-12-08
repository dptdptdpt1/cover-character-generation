# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.0-base

# Set CivitAI API key as environment variable
ENV CIVITAI_API_KEY=3ae740d22117cdcf3b1e399fc8a02f21

# install custom nodes into comfyui
RUN comfy node install --exit-on-fail comfyui-impact-subpack@1.3.5
RUN comfy node install --exit-on-fail comfyui-impact-pack@8.28.0
RUN comfy node install --exit-on-fail rgthree-comfy@1.0.2512060053
RUN comfy node install --exit-on-fail efficiency-nodes-comfyui@1.0.8
RUN comfy node install --exit-on-fail comfyui-custom-scripts@1.2.5

# download models into comfyui
RUN comfy model download --url https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt --relative-path models/diffusion_models --filename face_yolov8m.pt
RUN comfy model download --url https://huggingface.co/FacehugmanIII/4x_foolhardy_Remacri/resolve/main/4x_foolhardy_Remacri.pth --relative-path models/upscale_models --filename 4x_foolhardy_Remacri.pth
RUN comfy model download --url https://dl.fbaipublicfiles.com/segment_anything/sam_vit_b_01ec64.pth --relative-path models/diffusion_models --filename sam_vit_b_01ec64.pth

# ✅ 1. SDXL VAE - Official Stability AI version
RUN comfy model download --url https://huggingface.co/stabilityai/sdxl-vae/resolve/main/sdxl_vae.safetensors --relative-path models/vae --filename sdxl_vae.safetensors

# ✅ 2. PitEyeDetailer-v2-seg.pt - Eye detail detection model
RUN comfy model download --url https://huggingface.co/Outimus/Adetailer/resolve/main/PitEyeDetailer-v2-seg.pt --relative-path models/ultralytics/bbox --filename PitEyeDetailer-v2-seg.pt

# ✅ 3. HuslyoRealismXL V2 - Photorealistic checkpoint (version_id: 2399863)
RUN comfy model download --url "https://civitai.com/api/download/models/2399863?token=${CIVITAI_API_KEY}" --relative-path models/checkpoints --filename huslyorealismxl_v2.safetensors

# ✅ 4. Touch of Realism SDXL V2 - LoRA style model (version_id: 1934796)
RUN comfy model download --url "https://civitai.com/api/download/models/1934796?token=${CIVITAI_API_KEY}" --relative-path models/loras --filename Touch_of_Realism_SDXL_V2.safetensors

# ✅ 5. Woman877 Z-Image LoRA - Character LoRA (version_id: 2447895)
RUN comfy model download --url "https://civitai.com/api/download/models/2447895?token=${CIVITAI_API_KEY}" --relative-path models/loras --filename woman877-zimage.safetensors

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/
