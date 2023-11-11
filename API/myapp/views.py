from rest_framework import generics
from .models import Sector, Temperature, Watt
from .serializers import SectorSerializer, TemperatureSerializer, VoltageSerializer

class SectorList(generics.ListCreateAPIView):
    queryset = Sector.objects.all()
    serializer_class = SectorSerializer

class SectorDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Sector.objects.all()
    serializer_class = SectorSerializer

class TemperatureList(generics.ListCreateAPIView):
    queryset = Temperature.objects.all()
    serializer_class = TemperatureSerializer

class TemperatureDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Temperature.objects.all()
    serializer_class = TemperatureSerializer

class VoltageList(generics.ListCreateAPIView):
    queryset = Watt.objects.all()
    serializer_class = VoltageSerializer

class VoltageDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Watt.objects.all()
    serializer_class = VoltageSerializer

# views.py

from django.http import JsonResponse
from .models import FirestoreData
import json
from firebase_admin import firestore
import firebase_admin
from firebase_admin import credentials, firestore
import calendar
import time


cred = credentials.Certificate("myapp/hackathon-sfscon-edition-2023-firebase-adminsdk-8udi4-548d95d185.json")
firebase_admin.initialize_app(cred)

def save_firestore_data(request):
    firestore_client = firestore.client()

    sectors_ref = firestore_client.collection('Sectors')
    sec1_doc_ref = sectors_ref.document('Sec1')
    watt_docs = sec1_doc_ref.collection('Watt').stream()

    # Salva i dati nel modello Django
    for doc in watt_docs:
        data = doc.to_dict()
        document_id = doc.id

        # Verifica se il documento esiste già nel database Django
        if not FirestoreData.objects.filter(document_id=document_id).exists():
            FirestoreData.objects.create(document_id=document_id, data=json.dumps(data))

    return JsonResponse({'message': 'Dati salvati con successo'})


# serializers.py

# views.py

from rest_framework import generics
from .models import FirestoreData
from .serializers import FirestoreDataSerializer

class FirestoreDataList(generics.ListAPIView):
    queryset = FirestoreData.objects.all()
    serializer_class = FirestoreDataSerializer