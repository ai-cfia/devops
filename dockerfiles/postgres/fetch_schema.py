import os
import requests

BB_URL = os.getenv("BB_URL")
BB_SERVICE_ACCOUNT = os.getenv("BB_SERVICE_ACCOUNT")
BB_SERVICE_KEY = os.getenv("BB_SERVICE_KEY")
INSTANCE_ID = os.getenv("BB_INSTANCE_ID")
DATABASE_ID = os.getenv("BB_DATABASE_ID")

def generate_token():
    login_url = f"{BB_URL}/v1/auth/login"
    headers = {
        'Content-Type': 'application/json',
        'Accept-Encoding': 'deflate, gzip'
    }
    data = {
        "email": BB_SERVICE_ACCOUNT,
        "password": BB_SERVICE_KEY,
        "web": True
    }
    
    response = requests.post(login_url, json=data, headers=headers)
    if response.status_code == 200:
        return response.json().get('token')
    else:
        print(f"Failed to generate token: {response.status_code}, {response.text}")
        return None

def fetch_schema():
    token = generate_token()
    if token:
        schema_url = f"{BB_URL}/v1/instances/{INSTANCE_ID}/databases/{DATABASE_ID}/schema"
        headers = {
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json"
        }
        
        response = requests.get(schema_url, headers=headers)
        if response.status_code == 200:
            with open('schema.sql', 'w') as file:
                file.write(response.json()['schema'])
            print("Schema saved to schema.sql")
        else:
            print(f"Failed to fetch schema: {response.status_code}, {response.text}")
    else:
        print("No token generated, cannot fetch schema.")

if __name__ == "__main__":
    fetch_schema()
