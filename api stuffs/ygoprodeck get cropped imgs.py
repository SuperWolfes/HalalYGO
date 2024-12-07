import requests
import os

# API Endpoint for card data
api_url = "https://db.ygoprodeck.com/api/v7/cardinfo.php"

# Directory to save images
output_dir = "yugioh_cropped_images"
os.makedirs(output_dir, exist_ok=True)

# Fetch card data from the API
response = requests.get(api_url)
if response.status_code == 200:
    card_data = response.json()  # Parse JSON response
    if "data" in card_data:
        cards = card_data["data"]  # Get all card details
        print(f"Found {len(cards)} cards.")
        
        # Loop through cards and download only cropped images
        for card in cards:
            card_name = card["name"].replace(" ", "_").replace("/", "_")  # Safe filenames
            for image in card.get("card_images", []):
                cropped_url = image.get("image_url_cropped")  # Get cropped art URL
                if cropped_url:  # Ensure the field exists
                    file_name = f"{output_dir}/{image['id']}.jpg"
                    print(file_name)
                    # Download and save the cropped image
                    try:
                        print(f"Downloading {file_name}...")
                        img_response = requests.get(cropped_url)
                        if img_response.status_code == 200:
                            with open(file_name, "wb") as img_file:
                                img_file.write(img_response.content)
                        else:
                            print(f"Failed to download {cropped_url}: {img_response.status_code}")
                    except Exception as e:
                        print(f"Error downloading {cropped_url}: {e}")
    else:
        print("No card data found in the response.")
else:
    print(f"Failed to fetch data: {response.status_code}")
