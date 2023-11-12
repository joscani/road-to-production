## Arrancamos docker creado con valve

# system("nohup docker container run --rm -p 8083:8000 valve-docker > valve-docker.out 2>&1 &")

# con volumen para poder acceder a donde está descrito en el plumber
system("nohup docker run -v /media/hd1/canadasreche@gmail.com/Jornadas_barcelona_2023/road-to-production/Taller/modelos/modelo_vetiver:/media/hd1/canadasreche@gmail.com/Jornadas_barcelona_2023/road-to-production/Taller/modelos/modelo_vetiver --rm -p  8083:8000 valve-docker > valve-docker.out 2>&1 &")


library(tidyverse)
library(tidymodels)
data(Chicago)


## Predecir con la api dockerizada-----
base_url <- "http://0.0.0.0:8083"
api_res <- httr::POST(url = paste0(base_url, "/predict"),
                      body = head(Chicago),
                      encode = "json")
predicted_values <- httr::content(api_res, as = "text", encoding = "UTF-8")

jsonlite::fromJSON(predicted_values)

endpoint <- vetiver_endpoint("http://0.0.0.0:8083/predict")
predict(endpoint, Chicago)

system("docker stop $(docker ps -a -q)")
