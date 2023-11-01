## Arrancamos dockers creados con rocker-verse


## Arrancar docker creados------
# ojo con los puertos. comprobar que el Dockerfile expone en el mismo que ponemos abajo, en este caso el 8000,
# que mapeamos luego al 8083

 #nohup docker container run --rm -p 8083:8000 ejercio_taller_to_delete > ejercicio.out 2>&1 &


library(tidyverse)


test <-  read_csv(here::here("data/test_local.csv"))

test

base_url <- "http://0.0.0.0:8083"


(to_predict <-  head(test))



api_res <- httr::POST(url = paste0(base_url, "/predict"),
                      body = to_predict,
                      encode = "json")
predicted_values <- httr::content(api_res, as = "text", encoding = "UTF-8")

jsonlite::fromJSON(predicted_values)
