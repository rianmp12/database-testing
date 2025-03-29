import os
import time
import requests
import zipfile
from bs4 import BeautifulSoup, SoupStrainer
from urllib.parse import urljoin

base_url = "https://dadosabertos.ans.gov.br/FTP/PDA/demonstracoes_contabeis/"
download_dir = "./downloads/demonstracoes_contabeis"
target_years = ["2023", "2024"]
max_attempts = 10 # Criado para repetição de tentiva de downaload, pois pode ocorrer falhas ao tentar fazer download 

os.makedirs(download_dir, exist_ok=True)

response = requests.get(base_url)
soup = BeautifulSoup(response.text, "html.parser", parse_only=SoupStrainer("a"))

# Verifica se há as pastas /2023 e /2024, se sim, busca pelos .zip
for link in soup:
    href = link.get("href")
    if href and href.strip("/").isdigit() and href.strip("/") in target_years:
        year_url = urljoin(base_url, href)
        year_response = requests.get(year_url)
        year_soup = BeautifulSoup(year_response.text, "html.parser", parse_only=SoupStrainer("a"))

        for file_link in year_soup:
            file_href = file_link.get("href")
            if file_href and file_href.endswith(".zip"):
                file_url = urljoin(year_url, file_href)
                file_path = os.path.join(download_dir, file_href)

                print(f"Downloading: {file_href}")

                success = False
                for attempt in range(1, max_attempts + 1):
                    try:
                        with requests.get(file_url, stream=True, timeout=60) as r:
                            r.raise_for_status()
                            with open(file_path, "wb") as f:
                                for chunk in r.iter_content(chunk_size=8192):
                                    if chunk:
                                        f.write(chunk)
                        print(f"Sucess: {file_href}")
                        
                        with zipfile.ZipFile(file_path, 'r') as zip_ref:
                            zip_ref.extractall(download_dir)
                            print(f"Arquivo extraído: {file_href}")

                        os.remove(file_path)

                        success = True

                        break
                    except Exception as e:
                        print(f"Attempt {attempt} failed: {e}")
                        time.sleep(2)

                if not success:
                    print(f"Failed to download {file_href} after {max_attempts} attempts.")