import os
import requests
from bs4 import BeautifulSoup, SoupStrainer
from urllib.parse import urljoin

url = "https://dadosabertos.ans.gov.br/FTP/PDA/operadoras_de_plano_de_saude_ativas/"
destination = "./downloads/operadoras"

os.makedirs(destination, exist_ok=True)

response = requests.get(url)
soup = BeautifulSoup(response.text, "html.parser", parse_only=SoupStrainer("a"))

for link in soup:
    href = link.get("href")
    if href and href.endswith(".csv"):
        url_csv = urljoin(url, href)
        caminho_local = os.path.join(destination, href)

        print(f"Downloading: {href}")
        with requests.get(url_csv, stream=True) as r:
            with open(caminho_local, "wb") as f:
                for chunk in r.iter_content(chunk_size=8192):
                    f.write(chunk)