import os
import json
import requests # for GET requests
from bs4 import BeautifulSoup # to parse HTML

GOOGLE_IMAGE = \
    'https://www.google.com/search?site=&tbm=isch&source=hp&biw=1873&bih=990&'

# The User-Agent request header contains a characteristic string
# that allows the network protocol peers to identify the application type,
# operating system, and software version of the requesting software user agent.
# needed for google search
usr_agent = {
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Charset': 'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
    'Accept-Encoding': 'none',
    'Accept-Language': 'en-US,en;q=0.8',
    'Connection': 'keep-alive',
}

SAVE_FOLDER = 'C:/Users/risha/OneDrive/Desktop/images'

def download_images(save_folder, data, n_images):
    if not os.path.exists(save_folder):
        os.mkdir(save_folder)

    print('Searching...')

    # get url query string
    searchurl = GOOGLE_IMAGE + 'q=' + data

    response = requests.get(searchurl, headers=usr_agent)
    html = response.text

    # find all images
    soup = BeautifulSoup(html, 'html.parser')
    results = soup.findAll('img', limit=n_images)
    
    # get a list of image URLs
    imagelinks= []
    for r in results:
        text = str(r).split('src')[1].split('\"')[1]
        if len(text.split('https://')) > 1:
            imagelinks.append(text)

    print(f'found {len(imagelinks)} images')
    print('Downloading...')

    # download the images
    for i, imagelink in enumerate(imagelinks):
        # open image link and save as file
        response = requests.get(imagelink)

        imagename = save_folder + '/' + data.replace(" ", "_") + str(i+1) + '.jpg'
        with open(imagename, 'wb') as file:
            file.write(response.content)
    print('Done')


def find_all_images(file_name, dictionary_file_name, save_folder, n_images):
    read_file = open(file_name, "r")
    lines = read_file.readlines()

    dictionary_file = open(dictionary_file_name, "w")

    if not os.path.exists(save_folder):
        os.mkdir(save_folder)

    i = 0
    for line in lines:
        dictionary_file.write(str(i) + ' ' + line.strip().replace(" ", "_") + '\n')
        download_images(save_folder + '/' + str(i), line.strip(), n_images)
        i += 1

    dictionary_file.close()

find_all_images('WebScraper/foods.txt', 'WebScraper/dictionary.txt', 'WebScraper/images', 100)