from django.urls import path
from .views import SectorList, SectorDetail, TemperatureList, TemperatureDetail, VoltageList, VoltageDetail, save_firestore_data
from .views import FirestoreDataList


urlpatterns = [
    path('sectors/', SectorList.as_view(), name='sector-list'),
    path('sectors/<int:pk>/', SectorDetail.as_view(), name='sector-detail'),
    path('temperatures/', TemperatureList.as_view(), name='temperature-list'),
    path('temperatures/<int:pk>/', TemperatureDetail.as_view(), name='temperature-detail'),
    path('watt/', VoltageList.as_view(), name='voltage-list'),
    path('watt/<int:pk>/', VoltageDetail.as_view(), name='voltage-detail'),
    path('save_firestore_data/', save_firestore_data, name='save_firestore_data'),
    path('firestore_data/', FirestoreDataList.as_view(), name='firestore_data_list'),
    # Altri percorsi URL per le tue altre viste...
]