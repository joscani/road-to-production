En este `step` vemos un ejemplo de script que lee datos de una BD, predice y escribe en BD

* Se conecta a una BD , (en este caso algo simple con duckdb, pero podría ser MySql, Postgres o similar)
* Lee tabla de datos de test de un día determinado
* Predice y añade la predicción a tabla de predicciones y desconecta de la BD

La entrada en el crontab para que se ejecute diariamente a las 12 de la mañana y ponga notificación gráfica en ubuntu


```bash

DISPLAY=":0.0"
XAUTHORITY="/home/jose/.Xauthority" 
XDG_RUNTIME_DIR="/run/user/1000"
## cronR job
## id:   job_4b8bd0491c2b0a8870d42a2bd7a17da0
## tags: 
## desc: I execute things
00 12 * * *  /usr/bin/Rscript '/ruta_absoluta_al_repo/Taller/Step-1-batch-predict/01-2-predict_cronR.R'  >> '/ruta_absoluta_al_repo/Taller/Step-1-batch-predict/01-2-predict_cronR.log' 2>&1

```

