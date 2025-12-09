import json
import time
import base64
import requests
import os
from dotenv import load_dotenv

# 加载环境变量
load_dotenv()

RUNPOD_API_KEY = os.getenv("RUNPOD_API_KEY")
ENDPOINT_ID = os.getenv("ENDPOINT_ID")
WORKFLOW_JSON_FILE = "example-request.json"

RUN_URL = f"https://api.runpod.ai/v2/{ENDPOINT_ID}/run"
STATUS_URL = f"https://api.runpod.ai/v2/{ENDPOINT_ID}/status"
HEADERS = {"Authorization": f"Bearer {RUNPOD_API_KEY}"}


def load_workflow():
    """读取 ComfyUI 工作流 JSON 文件"""
    with open(WORKFLOW_JSON_FILE, "r", encoding="utf-8") as f:
        return json.load(f)


def submit_job(payload):
    """提交任务到 RunPod /run"""
    resp = requests.post(RUN_URL, json={"input": {"workflow": payload}}, headers=HEADERS)
    resp.raise_for_status()
    job_id = resp.json()["id"]
    print(f"[+] Job submitted: {job_id}")
    return job_id


def wait_for_result(job_id):
    """轮询任务状态直到完成"""
    status_url = f"{STATUS_URL}/{job_id}"

    while True:
        result = requests.get(status_url, headers=HEADERS).json()
        status = result.get("status")

        print(f"[~] Status: {status}")

        if status in ["COMPLETED", "FAILED"]:
            return result

        time.sleep(1)


def save_images(result):
    """保存 base64 图片"""
    if result.get("status") != "COMPLETED":
        print("[!] Task failed, no images saved.")
        return

    images = result["output"].get("images", [])
    if not images:
        print("[!] No images found in result.")
        return

    os.makedirs("output", exist_ok=True)

    for img in images:
        filename = img["filename"]
        img_bytes = base64.b64decode(img["data"])

        out_path = os.path.join("output", filename)
        with open(out_path, "wb") as f:
            f.write(img_bytes)

        print(f"[✔] Saved: {out_path}")


def main():
    print("[*] Loading workflow...")
    payload = load_workflow()

    print("[*] Submitting job...")
    job_id = submit_job(payload)

    print("[*] Waiting for result...")
    result = wait_for_result(job_id)

    print("[*] Saving images...")
    save_images(result)

    print("[✓] Done!")


if __name__ == "__main__":
    main()