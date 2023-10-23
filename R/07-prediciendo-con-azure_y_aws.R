##

library(tidyverse)
library(ggdist)



test <-  read_csv(here::here("data/test_local.csv"))

# puedes ponerlo como un container  o en azure servirlo como webapp
base_url <- "http://joscaniplumber.bzdcdcgzhxb0fpd3.eastus.azurecontainer.io:8080"


base_url <- "https://plumberrockerverse.azurewebsites.net"



api_res <- httr::POST(url = paste0(base_url, "/full_posterior"),
                      body = test[1:5,],
                      encode = "json")
predicted_values <- httr::content(api_res, as = "text", encoding = "UTF-8")

full_posterior <- jsonlite::fromJSON(predicted_values)

full_posterior %>%
  ggplot(aes(x = .epred, y = as_factor(.row))) +
  stat_halfeye()


### con más cores
## a veces tarda en conectarse, ir a azure y ver qué puede pasar.

base_url_async <- "https://bayesianplumber.azurewebsites.net"

api_res <- httr::POST(url = paste0(base_url_async, "/predict_async"),
                      body = test[1:5,],
                      encode = "json")
predicted_values <- httr::content(api_res, as = "text", encoding = "UTF-8")

jsonlite::fromJSON(predicted_values)

library(furrr)
plan(multisession, workers = 6, .cleanup = FALSE)
options(future.rng.onMisuse="ignore") # future issue


predict_with_plumber <- function( test, endpoint="/predict"){
  base_url <- "https://bayesianplumber.azurewebsites.net"
  test_json = jsonify::to_json(test)

  api_res <- httr::POST(url = paste0(base_url, endpoint),
                        body = test_json,
                        encode = "raw")
  predicted_values <- httr::content(api_res, as = "text", encoding = "UTF-8")
  RcppSimdJson::fparse(predicted_values)
}

# nohup docker container run --rm -p 8082:8082 r-minimal-plumber_async &
start <- Sys.time()
multiple_users_sequential <- future_map(1:6, ~ predict_with_plumber(head(test), "/predict"))

(multiple_users_sequential_time <-  Sys.time() - start)

# Time difference of 1.412479 mins


start <- Sys.time()
multiple_users_async <- future_map(1:6, ~ predict_with_plumber(head(test), "/predict_async"))

(multiple_users_async_time <-  Sys.time() - start)

# Time difference of 26.27049 secs

# curl -X POST \
# -H "Content-Type: application/json" \
# -d '{"segmento":"Rec","tipo":"C","valor_cliente":0,"edad_cat":"21- 40","n":132}' \
# https://bayesianplumber.azurewebsites.net/predict


## AWS-----

aws_url <- "https://46vrd9dczj.eu-west-1.awsapprunner.com:8080"
api_res <- httr::POST(url = paste0(aws_url, "/predict"),
                      body = test[1:5,],
                      encode = "json")
predicted_values <- httr::content(api_res, as = "text", encoding = "UTF-8")
