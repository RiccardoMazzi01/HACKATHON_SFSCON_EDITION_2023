import calendar
import json
import time

import firebase_admin
import requests
from firebase_admin import firestore, credentials

from demo_use_case import demo_use_case_predict
from model import use_case_predict

indirizzo_ip = "10.199.225.1"
#url1 = f"http://{indirizzo_ip}/rpc"
url="http://10.199.225.1/rpc/Shelly.GetStatus"
apower_array=[]
cred = credentials.Certificate("./hackathon-sfscon-edition-2023-firebase-adminsdk-8udi4-548d95d185.json")
firebase_admin.initialize_app(cred)
def post(valore,tipo):
    firestore_client = firestore.client()

    sectors_ref = firestore_client.collection('Sectors')

    sec1_doc_ref = sectors_ref.document('Sec1')

    watt_docs = sec1_doc_ref.collection(tipo).stream()

    last_watt_id = None
    last_number=-1
    for doc in watt_docs:
        last_watt_id = doc.id
        last_watt_id = int(last_watt_id[len('time'):])
        if last_watt_id > last_number:
            last_number=last_watt_id
    print("ultimo id è:",last_number)


    new_number = last_number + 1
    new_watt_id = f'time{new_number}'

    current_GMT = time.gmtime()
    valore = float(valore)
    time_stamp = calendar.timegm(current_GMT)
    new_watt_data = {
        'timestamp': time_stamp,
        'value': valore,
        'anomaly':use_case_predict(valore)


    }

    new_watt_doc_ref = sec1_doc_ref.collection(tipo).document(new_watt_id)
    new_watt_doc_ref.set(new_watt_data)

    print(f'Nuovo documento Watt aggiunto con ID: {new_watt_id}')


while True:
    try:
        response = requests.get(url)

        print(f"Status Code: {response.status_code}")
        print("Response Content:")
        print(response.text)
        data = json.loads(response.text)

        apower_value = data.get('switch:0', {}).get('apower')
        post(apower_value,"Watt")
    except requests.RequestException as e:
        print(f"Errore durante la richiesta: {e}")
    time.sleep(3)






