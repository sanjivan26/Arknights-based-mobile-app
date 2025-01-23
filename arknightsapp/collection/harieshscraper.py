import os
import random
import requests
import time

# Base URL of the avatars or images
BASE_URL = "https://raw.githubusercontent.com/Aceship/Arknight-Images/main/avatars/"  # Adjust if needed

# List of file names to download
keys_file_path = r"assets\collection\keys .txt"

# Folder to save the downloaded files
output_folder = r"assets\avatars"
os.makedirs(output_folder, exist_ok=True)

# List of user agents for request headers
user_agents = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1",
    "Mozilla/5.0 (Linux; Android 10; SM-A505F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Mobile Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/109.0",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.5359.125 Safari/537.36",
    "Mozilla/5.0 (Linux; Android 11; SM-G981B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Mobile Safari/537.36",
    "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36",
    "Mozilla/5.0 (iPad; CPU OS 15_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1",
    "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:85.0) Gecko/20100101 Firefox/85.0",
    "Mozilla/5.0 (Linux; Android 8.0.0; Nexus 5X) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.84 Mobile Safari/537.36",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 Safari/604.1",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; Trident/7.0; rv:11.0) like Gecko",
    "Mozilla/5.0 (X11; Linux i686; rv:45.0) Gecko/20100101 Firefox/45.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:91.0) Gecko/20100101 Firefox/91.0",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 11_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.0 Mobile/15E148 Safari/604.1",
]

def read_file_names_from_txt(file_path):
    """Reads file names from the given text file and returns a list of file names."""
    file_names = []
    try:
        with open(file_path, "r") as file:
            file_names = [line.strip() for line in file if line.strip()]  # Read lines and remove extra whitespace
    except FileNotFoundError:
        print(f"Error: {file_path} not found.")
    file_names_final = []
    for i in file_names:
        file_names_final.append(i+".png")
    return file_names_final

def download_images(base_url, file_names, output_folder):
    """
    Downloads images from the given base URL and saves them in the specified folder.
    """
    for file_name in file_names:
        file_url = f"{base_url}{file_name}"  # Construct full URL
        headers = {"User-Agent": random.choice(user_agents)}  # Randomize user-agent
        try:
            response = requests.get(file_url, headers=headers, timeout=10)
            if response.status_code == 200:
                # Save the file to the output folder
                file_path = os.path.join(output_folder, file_name)
                with open(file_path, "wb") as file:
                    file.write(response.content)
                print(f"Downloaded: {file_name}")
            else:
                print(f"Failed to download: {file_name} (Status: {response.status_code})")
        except requests.exceptions.RequestException as e:
            print(f"Error downloading {file_name}: {e}")
        
        # Sleep for a random time between 1 and 7 seconds
        time_to_sleep = random.randint(2, 7)  # Random integer between 1 and 7
        print(f"Sleeping for {time_to_sleep} seconds before the next request...")
        time.sleep(time_to_sleep)

# Read the file names from the keys.txt file
file_names = read_file_names_from_txt(keys_file_path)

# Run the download function if file names are successfully loaded
if file_names:
    download_images(BASE_URL, file_names, output_folder)
else:
    print("No file names found to download.")
