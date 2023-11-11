import firebase_admin
from firebase_admin import credentials, firestore
import calendar
import time


cred = credentials.Certificate("./hackathon-sfscon-edition-2023-firebase-adminsdk-8udi4-548d95d185.json")
firebase_admin.initialize_app(cred)

def get():
    firestore_client = firestore.client()
    '''
    ind1_ref = firestore_client.document("Industries/Ind1")

        # Utilizzo della funzione 'where' nella query per filtrare i documenti
    #query = firestore_client.collection("Sectors")#.where("Industry","==",ind1_ref)
    query = firestore_client.collection("Sec1").where("Sectors","==","stanza1")  # .where("Industry","==",ind1_ref)
        # Esecuzione effettiva della query
    col = query.get()
    array=[]
    for doc in col:
        array.append(doc.to_dict())

    print(type(array))
    print(array)'''


    # Inizializza il client Firestore


    # Ottieni un riferimento alla raccolta "Sectors"
    sectors_ref = firestore_client.collection('Sectors')

    # Ottieni un riferimento al documento "Sec1" all'interno della raccolta "Sectors"
    sec1_doc_ref = sectors_ref.document('Sec1')

    # Esegui una query per ottenere tutti i documenti dalla raccolta "Sec1"
    '''sec1_docs = sec1_doc_ref.collections()

    # Itera sui documenti ottenuti dalla query e stampa i dati
    for collection in sec1_docs:
        print(f'Raccolta: {collection.id}')
        for doc in collection.stream():
            print(f'  Document ID: {doc.id}, Data: {doc.to_dict()}')
    '''


    # Ottieni un riferimento al documento "Sec1" all'interno della raccolta "Sectors"


    # Esegui una query per ottenere tutti i documenti dalla raccolta "Watt" all'interno del documento "Sec1"
    watt_docs = sec1_doc_ref.collection('Watt').stream()

    # Itera sui documenti ottenuti dalla query e stampa i dati
    for doc in watt_docs:
        print(f'Document ID: {doc.id}, Data: {doc.to_dict()}')

def post(valore,tipo):
    # Inizializza il client Firestore
    firestore_client = firestore.client()

    # Ottieni un riferimento alla raccolta "Sectors"
    sectors_ref = firestore_client.collection('Sectors')

    # Ottieni un riferimento al documento "Sec1" all'interno della raccolta "Sectors"
    sec1_doc_ref = sectors_ref.document('Sec1')

    # Esegui una query per ottenere tutti i documenti dalla raccolta "Watt" all'interno del documento "Sec1"
    watt_docs = sec1_doc_ref.collection(tipo).stream()

    # Ottieni l'ID dell'ultimo documento
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
    valore = int(valore)
    time_stamp = calendar.timegm(current_GMT)
    # Definisci i dati che vuoi aggiungere al nuovo documento nella raccolta "Watt"
    new_watt_data = {
        'timestamp': time_stamp,
        'value': valore,

        # Aggiungi altri campi e valori secondo le tue esigenze
    }

    # Aggiungi un nuovo documento alla raccolta "Watt" con l'ID specificato
    new_watt_doc_ref = sec1_doc_ref.collection(tipo).document(new_watt_id)
    new_watt_doc_ref.set(new_watt_data)

    # Stampa l'ID del nuovo documento creato
    print(f'Nuovo documento Watt aggiunto con ID: {new_watt_id}')


def UpdateSectors(update_dict): #dizionario con nome, temperatura:nuova_temperatura
        db = firestore.client()
        shoes_ref = db.collection("Sectors")

        query = shoes_ref.where("id", "==", update_dict["id"]).limit(1)
        matching_shoes = query.get()
        if not len(matching_shoes) == 0:
            # Prendi il primo documento trovato (limit(1) dovrebbe assicurare che ci sia solo uno)
            documento = matching_shoes[0]

            # Modifica il documento con i nuovi dati
            documento.reference.update(update_dict)

            print("Proprietà aggiornata")
        else:
            # Documento non trovato
            print("Nessun documento trovato")

#get()
#post()

post(40,"Watt")