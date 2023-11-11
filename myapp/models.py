from django.db import models

# Create your models here.
# models.py


from django.db import models

class Sector(models.Model):
    nome = models.CharField(max_length=255)

    def __str__(self):
        return self.nome


from django.db import models

class Temperature(models.Model):
    sector = models.ForeignKey(Sector, related_name='temperatures', on_delete=models.CASCADE)
    value = models.FloatField()
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'Temperature for {self.sector.nome}'

class Watt(models.Model):
    sector = models.ForeignKey(Sector, related_name='watt', on_delete=models.CASCADE)
    value = models.FloatField()
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'Voltage for {self.sector.nome}'

# models.py

from django.db import models

class FirestoreData(models.Model):
    document_id = models.CharField(max_length=255, unique=True)
    data = models.JSONField()
