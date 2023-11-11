from rest_framework import serializers
from .models import Sector, Temperature, Watt

class SectorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Sector
        fields = ('id', 'nome')

class TemperatureSerializer(serializers.ModelSerializer):
    sector = SectorSerializer()

    class Meta:
        model = Temperature
        fields = ('id', 'sector', 'value', 'timestamp')

class VoltageSerializer(serializers.ModelSerializer):
    sector = SectorSerializer()

    class Meta:
        model = Watt
        fields = ('id', 'sector', 'value', 'timestamp')



# serializers.py

from rest_framework import serializers
from .models import FirestoreData

class FirestoreDataSerializer(serializers.ModelSerializer):
    class Meta:
        model = FirestoreData
        fields = ['document_id', 'data']