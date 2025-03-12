import requests
from bs4 import BeautifulSoup
import csv

# URL to scrape
url = 'https://help.imdb.com/article/contribution/other-submission-guides/country-codes/G99K4LFRMSC37DCN#'

# Send HTTP request to the URL
response = requests.get(url)

# Parse the content with BeautifulSoup
soup = BeautifulSoup(response.content, 'html.parser')

# Find all the <ul> elements inside <td> tags (they contain country codes and names)
country_data = []

# Locate all the <td> elements that contain the <ul> lists
ul_elements = soup.find_all('td', valign='top')

# Iterate over each <ul> list and extract country names and codes
for ul in ul_elements:
    # Extract all <li> tags inside each <ul>
    list_items = ul.find_all('li')

    # Iterate through each list item and split the code and country name
    for item in list_items:
        country_info = item.get_text(strip=True)
        # Split country code and name, assuming format "code country_name"
        parts = country_info.split(' ', 1)  # Split into country code and country name
        if len(parts) == 2:
            country_code = parts[0]
            country_name = parts[1]
            country_data.append((country_name, country_code))  # Store as a tuple (CountryName, CountryCode)

# Define the CSV file path
csv_filename = 'country_codes.csv'

# Write the extracted data into a CSV file
with open(csv_filename, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)

    # Write the header
    writer.writerow(['Country Name', 'Country Code'])

    # Write the country data
    for country_name, country_code in country_data:
        writer.writerow([country_name, country_code])

print(f"Data has been written to {csv_filename}")
