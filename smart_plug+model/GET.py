import firebase_admin
from firebase_admin import credentials, firestore, db

cred = credentials.Certificate("/Users/michelemenabeni/PycharmProjects/NoiHackathon/hackathon-sfscon-edition-2023-firebase-adminsdk-8udi4-548d95d185.json")
firebase_admin.initialize_app(cred)

def get(id_stanza):
    firestore_client = firestore.client()

    collezione_ref = firestore_client.collection("Sectors")#.document(documento_id).collection(collezione_nome)
    arrayT = []
    arrayW = []
    documenti = collezione_ref.stream()
    for doc in documenti:
        if doc.id==id_stanza:
            documento_ref = firestore_client.collection("Sectors").document(doc.id)

            queryT=documento_ref.collection("Temperature")
            queryW=documento_ref.collection("Watt")

            temp=queryW.stream()
            watt=queryT.stream()

            for t in temp:
                arrayT.append(t.to_dict())
            for w in watt:
                arrayW.append(w.to_dict())
        else:
            pass
    print(arrayW,arrayT)
get("Sec1")
