import requests
import socket
import time

# Backend server URL (Change IP if needed)
BACKEND_URL = "http://127.0.0.1:8000"

# Get the local machine's IP address
def get_local_ip():
    try:
        return socket.gethostbyname(socket.gethostname())
    except Exception as e:
        print(f"Error getting local IP: {e}")
        return "127.0.0.1"

# Register this node with the backend
def register_node():
    node_ip = get_local_ip()
    payload = {"ip_address": node_ip}

    try:
        response = requests.post(f"{BACKEND_URL}/nodes/register", json=payload)
        if response.status_code == 200:
            print(f"[✔] Node registered: {node_ip}")
        else:
            print(f"[X] Failed to register node: {response.json()}")
    except Exception as e:
        print(f"[ERROR] Could not reach backend: {e}")

# Submit a test post to the backend
def submit_post():
    node_ip = get_local_ip()
    payload = {
        "title": "LAN Node Test Post",
        "content": "This is a test message from the node!",
        "node_id": 1  # Change this to the correct node ID
    }

    try:
        response = requests.post(f"{BACKEND_URL}/posts/", json=payload)
        if response.status_code == 200:
            print("[✔] Post submitted successfully!")
        else:
            print(f"[X] Failed to submit post: {response.json()}")
    except Exception as e:
        print(f"[ERROR] Could not submit post: {e}")

# Retrieve posts from the backend
def get_posts():
    try:
        response = requests.get(f"{BACKEND_URL}/posts/")
        if response.status_code == 200:
            posts = response.json()
            print(f"[✔] Retrieved {len(posts)} posts!")
            for post in posts:
                print(f"- {post['title']}: {post['content']}")
        else:
            print(f"[X] Failed to get posts: {response.json()}")
    except Exception as e:
        print(f"[ERROR] Could not retrieve posts: {e}")

# Main loop
if __name__ == "__main__":
    print("[🔄] Starting LAN Node Client...")
    register_node()
    time.sleep(2)
    submit_post()
    time.sleep(2)
    get_posts()
