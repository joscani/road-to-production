
# nohup docker container run --rm -p 8083:8000 taller_docker > taller.out 2>&1 &

curl -X POST -H "Content-Type: application/json" -d '{"segmento":"Rec","tipo":"C","valor_cliente"
:0,"edad_cat":"21- 40","n":132}' http://0.0.0.0:8083/predict

curl -X POST -H "Content-Type: application/json" -d '[{"segmento":"Rec","tipo":"C","valor_cliente":0.0,"edad_cat":"21- 40","n":132.0},{"segmento":"Best","tipo":"B","valor_cliente":0.0,"edad_cat":"41-50","n":19.0},{"segmento":"Neut","tipo":"SM","valor_cliente":0.0,"edad_cat":"41-50","n":98.0},{"segmento":"Rec","tipo":"B","valor_cliente":0.0,"edad_cat":"41-50","n":7.0},{"segmento":"Neut","tipo":"SM","valor_cliente":0.0,"edad_cat":"40-60","n":66.0}]' http://0.0.0.0:8083/predict
