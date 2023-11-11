import serial
import time

import Firebase

#from Firebase import *
# Imposta la porta seriale e la velocità di trasmissione
ser = serial.Serial('COM3', 9600)  # Assicurati di impostare la porta giusta
temperatura2=0
try:
    while True:
        # Leggi una riga di dati dalla porta seriale
        line = ser.readline().decode('utf-8').strip()
        #print("prova")
        # Verifica se la riga contiene informazioni sulla temperatura
        if "LSM6DSOX Temperature" in line:
            # Estrai e stampa solo la parte relativa alla temperatura
            temperature_data = line.split('=')[1].strip()
            temperature_data = temperature_data[:2]
            if temperatura2!=temperature_data:
                print(temperature_data)
                #UpdateSectors({"id":"Sec1","Temp":temperature_data})
                #UpdateSectors({"id":"Sec1","Temp":20})
                Firebase.post(temperature_data,'Temperature')
            temperatura2= temperature_data

        # Aggiungi un piccolo ritardo per evitare la lettura troppo veloce
        time.sleep(0.1)

except KeyboardInterrupt:
    # Chiudi la porta seriale quando il programma viene interrotto
    ser.close()
    print("Porta seriale chiusa.")
