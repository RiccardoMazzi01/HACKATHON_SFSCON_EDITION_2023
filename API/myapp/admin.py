from django.contrib import admin
from .models import *
# Register your models here.

admin.site.register(Temperature)
admin.site.register(Watt)
admin.site.register(Sector)
admin.site.register(FirestoreData)