nohup docker container run --rm -p 8083:8000 taller_docker > taller.out 2>&1 &

import subprocess
import requests
import json
import pandas as pd


subprocess.run("nohup docker container run --rm -p 8083:8000 taller_docker > taller.out 2>&1 &", shell = True)



api_url = "http://0.0.0.0:8083/"

# una observación 
test = [{"segmento":"Rec","tipo":"C","valor_cliente":0,"edad_cat":"21- 40","n":132}]

response = requests.post(api_url + "predict", json=test)
json_res = response.json()
print(json_res)

df = pd.DataFrame(json_res)
df



test = pd.read_csv("data/test_local.csv").head()

# tras un par de  preguntas a chatgpt para quitar la comillas simples de data_json
data_json = test.to_json(orient='records') 

json_data = json.loads(data_json)


# data_json = [{"segmento":"Rec","tipo":"C","valor_cliente":0.0,"edad_cat":"21- 40","n":132.0},{"segmento":"Best","tipo":"B","valor_cliente":0.0,"edad_cat":"41-50","n":19.0},{"segmento":"Neut","tipo":"SM","valor_cliente":0.0,"edad_cat":"41-50","n":98.0},{"segmento":"Rec","tipo":"B","valor_cliente":0.0,"edad_cat":"41-50","n":7.0},{"segmento":"Neut","tipo":"SM","valor_cliente":0.0,"edad_cat":"40-60","n":66.0}]


headers = {'Content-Type': 'application/json'}  # Encabezados para indicar que estás enviando JSON

# Enviar la solicitud POST con el JSON como datos
response = requests.post(api_url + "predict", json=json_data, headers=headers)
json_res = response.json()
print(json_res)

predicciones = pd.DataFrame(json_res)
predicciones
