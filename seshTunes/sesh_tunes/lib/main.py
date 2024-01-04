import spotipy
from spotipy.oauth2 import SpotifyOAuth
import json
import sys
import time
import requests
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
from pprint import pprint

def generate_spotify_code_image(uri):
    driver = webdriver.Chrome()

    try:
        # Open the Spotify Code URI in the browser
        driver.get(f'{uri}')

        # Wait for the page to load (adjust the sleep duration if needed)
        time.sleep(60)

        # Click the "Download" button
        # download_button = driver.find_element_by_id('download-button')
        # download_button.click()

        # Wait for the download to complete (adjust the sleep duration if needed)
        time.sleep(5)

        print('Spotify Code image downloaded successfully')

    finally:
        driver.quit()

def automate_browser(url, webdriver_path, uri):
    # Create ChromeOptions object and set the executable path
    chrome_options = Options()
    chrome_options.add_argument(f"executable_path={webdriver_path}")

    # Create a new instance of the Chrome driver with ChromeOptions
    driver = webdriver.Chrome(options=chrome_options)

    try:
        # Navigate to the specified URL
        test_input = "TESTWR"
        driver.get(url)
        input_field = driver.find_element(By.NAME, "uri")
        print(input_field)
        input_field.clear()
        input_field.send_keys(uri)
        get_spotify_code_submit = driver.find_element(By.CSS_SELECTOR, ".uri-button")
        get_spotify_code_submit.click()

        final_button = driver.find_element(By.XPATH, "/html/body/div[2]/div[3]/div[1]/div")
        
        print(get_spotify_code_submit)
        
        
        time.sleep(120)

        # Add additional automation steps as needed

    finally:
        # Close the browser window, even if an exception occurs
        driver.quit()

def get_recommendations(username, client_id, client_secret, redirect_uri, seed_genres):
    # Set up Spotify API authentication
    sp = spotipy.Spotify(
        auth_manager=SpotifyOAuth(
            client_id=client_id,
            client_secret=client_secret,
            redirect_uri=redirect_uri,
            scope="playlist-modify-public",
            username=username,
        )
    )

    # Get recommendations based on seed tracks
    recommendations = sp.recommendations(seed_genres=seed_genres, limit=1)
    return json.dumps(recommendations)

def prepare_json():
    username = "Cameron McCoy"
    client_id = "468008742c384ca4b0b7caca927aabdb"
    client_secret = "f1dd1e37ad2d4d6593e6a4fd43d99760"
    redirect_uri = "http://localhost:3000/callback"

    # Provide a list of seed track IDs
    
    seed_genres = [
        "classical",
        "jazz",
        "chill",
        "rainy-day"
    ]
    # Call the function and get results
    result = get_recommendations(username, client_id, client_secret, redirect_uri, seed_genres)
    result = json.loads(result)
    result = result["tracks"][0]
    result2 = result['album']
    
    spotify_url = result2['external_urls']
    spotify_url = spotify_url['spotify']
    images = result2['images'][0]
    artist_name = result["name"]
    preview_url = result['preview_url']
    uri = result['uri']
    
    payload = {
        'arist_name': artist_name,
        'preview_url': preview_url,
        'uri': uri,
        'song_cover': images,
        'spotify_url': spotify_url

    }


    json_data = json.dumps(payload)
    return json_data
    




if __name__ == "__main__":
    # Replace these values with your Spotify API credentials
    
    ##### TEST CODE FOR AUTOMATING URI GENERATION
    # url_to_navigate = 'https://www.spotifycodes.com'
    # chromedriver_path = '/var/folders/s8/9g7r1yfx7rz77z63skz4zznr0000gp/T/wzQL.k0gsFw/chromedriver'
    # automate_browser(url_to_navigate, chromedriver_path, uri)
    json = prepare_json()
    
    
    

