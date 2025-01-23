import os
import random
import requests
from bs4 import BeautifulSoup

BASE_URL = "https://aceship.github.io/AN-EN-Tags/akhrchars.html?opname=Bagpipe"
SAVE_FOLDER = "./images"  # Folder to save the images

# List of user agents for request headers
user_agents = user_agents = [
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

def scrape_debug_all_images(url: str):
    try:
        headers = {"User-Agent": random.choice(user_agents)}
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()

        # Parse the page content with BeautifulSoup
        soup = BeautifulSoup(response.text, "html.parser")

        # Find all <img> tags and print them
        img_tags = soup.find_all("img")
        print(f"Found {len(img_tags)} <img> tags.")
        for img in img_tags:
            print(img)
    except requests.exceptions.RequestException as e:
        print(f"Failed to scrape page: {e}")

scrape_debug_all_images(BASE_URL)


def download_image(image_url: str, save_path: str):
    """
    Downloads an image from the given URL and saves it to the specified path.
    """
    try:
        headers = {"User-Agent": random.choice(user_agents)}
        response = requests.get(image_url, headers=headers, timeout=10)
        response.raise_for_status()  # Raise an exception for HTTP errors

        # Save the image content to a file
        with open(save_path, "wb") as file:
            file.write(response.content)
        print(f"Image saved to {save_path}")
    except requests.exceptions.RequestException as e:
        print(f"Failed to download image {image_url}: {e}")

def scrape_and_download_image(url: str):
    """
    Scrapes the given URL, finds the target image, and downloads it.
    """
    try:
        headers = {"User-Agent": random.choice(user_agents)}
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()

        # Parse the page content with BeautifulSoup
        soup = BeautifulSoup(response.text, "html.parser")

        # Look for the image tag with the specified attributes
        classname ="article-media-placeholder lazyload"
        altname ="Surtr icon"
        img_tag = soup.find("img", class_=classname, alt=altname)
        if img_tag and "src" in img_tag.attrs:
            image_url = img_tag["src"]  # Extract the image URL
            image_name = os.path.basename(image_url.split("?")[0])  # Get the file name
            save_path = os.path.join(SAVE_FOLDER, image_name)

            # Ensure the save folder exists
            os.makedirs(SAVE_FOLDER, exist_ok=True)

            # Download the image
            download_image(image_url, save_path)
        else:
            print("No image found with class=",classname," and alt=",altname)
    except requests.exceptions.RequestException as e:
        print(f"Failed to scrape page: {e}")

# Run the scraper
# scrape_and_download_image(BASE_URL)
scrape_debug_all_images(BASE_URL)