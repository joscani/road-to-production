# predecir en local plumber api.
# arrancar plumber primero en segundo plano
# se podría hacer por bash

# curl -X POST \
# -H "Content-Type: application/json" \
# -d '{"segmento":"Rec","tipo":"C","valor_cliente":0,"edad_cat":"21- 40","n":132}' \
# http://127.0.0.1:8000/predict

library(tidyverse)
library(ggdist)

test <-  read_csv(here::here("data/test_local.csv"))

base_url <- "http://127.0.0.1:8000"

api_res <- httr::POST(url = paste0(base_url, "/predict"),
                      body = head(test),
                      encode = "json")
predicted_values <- httr::content(api_res, as = "text", encoding = "UTF-8")

jsonlite::fromJSON(predicted_values)


api_res2 <- httr::POST(url = paste0(base_url, "/full_posterior"),
                       body = head(test),
                       encode = "json")
posterior_values <- httr::content(api_res2, as = "text", encoding = "UTF-8")


posterior_values <- jsonlite::fromJSON(posterior_values)



posterior_values %>%
  ggplot(aes(x=.epred, y = as_factor(.row))) +
  ggdist::stat_halfeye()

