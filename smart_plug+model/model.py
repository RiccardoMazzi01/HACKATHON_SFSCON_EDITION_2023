import joblib
import numpy as np
from sklearn.svm import OneClassSVM

#Model Used for the demo
model = OneClassSVM(nu=0.4)
with open('dataset.txt', 'r') as file:
    vettore_dati = []

    for riga in file:
        riga=riga.replace(",","")
        valore_float = float(riga.strip())  # strip() rimuove eventuali spazi o caratteri di nuova linea
        vettore_dati.append(valore_float)
#model.predict(X_train)
print(sum(vettore_dati)/len(vettore_dati))
X_train=np.array(vettore_dati)
X_train=X_train.reshape(-1,1)
model.fit(X_train)
joblib.dump(model, 'model4.pkl')



def use_case_predict(value):
    model = joblib.load('/Users/michelemenabeni/PycharmProjects/NoiHackathon/model4.pkl')
    x=np.array([value]).reshape(-1,1)
    y=model.predict(x)
    print(y)

