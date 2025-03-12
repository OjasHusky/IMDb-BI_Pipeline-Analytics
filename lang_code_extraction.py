import requests
from bs4 import BeautifulSoup
import pandas as pd

# URL of the page to scrape
url = 'https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes'
response = requests.get(url)
soup = BeautifulSoup(response.content, 'html.parser')

# Find the first table on the page
table = soup.find('table', class_='wikitable')

# Extract rows from the table
rows = table.find_all('tr')

# Extract first and second columns
data = []
for row in rows[1:]:  # Skip the header row
    cols = row.find_all('td')
    if len(cols) >= 2:  # Ensure there are at least two columns
        first_col = cols[0].text.strip()
        second_col = cols[1].text.strip()

        # Keep only the first word of the first column
        first_col = first_col.split()[0]  # Split and take the first word

        # Remove any commas from the first column
        first_col = first_col.replace(',', '')

        data.append([first_col, second_col])

# Create a DataFrame and name columns
df = pd.DataFrame(data, columns=['languagename', 'languagecode'])

# Save the DataFrame to a CSV file
df.to_csv('language_codes.csv', index=False)

# Optional: Display the first few rows
print(df)
