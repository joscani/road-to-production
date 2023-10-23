import requests
import json
import pandas as pd

api_url = "https://bayesianplumber.azurewebsites.net/"
response = requests.get(api_url + "health")
print(response.text)


# para el full posterior es necesario poner [ y ] al inicio y al final



test = [{"segmento":"Rec","tipo":"C","valor_cliente":0,"edad_cat":"21- 40","n":132}]

response = requests.post(api_url + "predict", json=test)
json_res = response.json()
print(json_res)

df = pd.DataFrame(json_res)
df


test_from_r = r.test.head()

# tras un par de  preguntas a chatgpt para quitar la comillas simples de data_json
data_json = test_from_r.to_json(orient='records') 

json_data = json.loads(data_json)


# data_json = [{"segmento":"Rec","tipo":"C","valor_cliente":0.0,"edad_cat":"21- 40","n":132.0},{"segmento":"Best","tipo":"B","valor_cliente":0.0,"edad_cat":"41-50","n":19.0},{"segmento":"Neut","tipo":"SM","valor_cliente":0.0,"edad_cat":"41-50","n":98.0},{"segmento":"Rec","tipo":"B","valor_cliente":0.0,"edad_cat":"41-50","n":7.0},{"segmento":"Neut","tipo":"SM","valor_cliente":0.0,"edad_cat":"40-60","n":66.0}]


headers = {'Content-Type': 'application/json'}  # Encabezados para indicar que estás enviando JSON

# Enviar la solicitud POST con el JSON como datos
response = requests.post(api_url + "predict", json=json_data, headers=headers)
json_res = response.json()
print(json_res)

df = pd.DataFrame(json_res)
df
