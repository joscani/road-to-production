
# Tiene que estar corriendo la api, ejecutar en segundo plano fichero 02-launch.R


library(tidyverse)

test <- modeldata::Chicago %>% slice_tail(n = 4)
# Elegimos algunas filas


## Predecir con eel api de vetiver .
## primera forma

base_url <- "http://127.0.0.1:8080"
api_res <- httr::POST(url = paste0(base_url, "/predict"),
                      body = test,
                      encode = "json")
predicted_values <- httr::content(api_res, as = "text", encoding = "UTF-8")

jsonlite::fromJSON(predicted_values)


# segunda forma
library(vetiver)

endpoint <- vetiver_endpoint("http://127.0.0.1:8080/predict")
predict(endpoint, test)


