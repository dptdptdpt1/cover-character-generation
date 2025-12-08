# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.0-base

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
# RUN # Could not find URL for SDXL/sdxl_vae.safetensors
# RUN # Could not find URL for bbox/PitEyeDetailer-v2-seg.pt
# RUN # Could not find URL for checkpoints/huslyorealismxl_v2.safetensors
# RUN # Could not find URL for Touch_of_Realism_SDXL_V2.safetensors
# RUN # Could not find URL for woman877-zimage.safetensors

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/