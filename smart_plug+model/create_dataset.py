import json

indirizzo_ip = "10.199.225.1"
url="http://10.199.225.1/rpc/Shelly.GetStatus"
apower_array=[]
import requests

for x in range(0,800,1):
    try:
        # Esegui la richiesta GET
        response = requests.get(url)

        # Stampa il codice di stato e il contenuto della risposta
        print(f"Status Code: {response.status_code}")
        print("Response Content:")
        print(response.text)
        data = json.loads(response.text)

    # Estrai il valore di 'apower' associato a 'switch:0'
        apower_value = data.get('switch:0', {}).get('apower')
        apower_array.append(apower_value)
    except requests.RequestException as e:
        print(f"Errore durante la richiesta: {e}")


with open("dataset.txt", 'w') as file:
    # Scrivere ogni elemento dell'array su una nuova riga
    for value in apower_array:
        file.write(f'{value},\n')