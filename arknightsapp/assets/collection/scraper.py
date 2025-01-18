import requests
from bs4 import BeautifulSoup

# URL of the webpage to scrape
url = "https://x.com/ArknightsEN"

# Fetch the content of the URL
response = requests.get(url)

# Check if the request was successful
if response.status_code == 200:
    # Parse the HTML content
    soup = BeautifulSoup(response.text, 'html.parser')
    print(soup.prettify())  # Print the HTML in a pretty format
else:
    print(f"Failed to fetch the URL. Status code: {response.status_code}")
